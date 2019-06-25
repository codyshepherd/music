package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"net/http"

	log "github.com/sirupsen/logrus"

	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
	"golang.org/x/crypto/bcrypt"
)

var db *Database

const registeredTableName = "registered"
const schema = "registered_accounts"

var idCounter = 0

func main() {

	// get any cli options
	var credsFile string
	var listenPort string
	var logLevel string
	flag.StringVar(&credsFile, "creds", "psql_creds.rc",
		"File to find Postgres credentials")
	flag.StringVar(&listenPort, "port", "9000",
		"port for server to listen on")
	flag.StringVar(&logLevel, "log", "v",
		"Log Levels\nn: Errors only\nq: Info\nv: Debug\nvvv: Trace")
	flag.Parse()

	// set log level
	var ll log.Level
	switch logLevel {
	case "n":
		ll = log.ErrorLevel
	case "q":
		ll = log.InfoLevel
	case "v":
		ll = log.DebugLevel
	case "vvv":
		ll = log.TraceLevel
	}
	log.SetLevel(ll)
	dbName := "accounts"

	db = dbInit(credsFile, dbName, registeredTableName)
	defer db.Close()
	log.Info("Webserver start")
	log.Info("Lisening on port: " + listenPort)

	// instantiate the web router
	r := mux.NewRouter()

	// Handle calls to index and elm.js with same function
	// r.HandleFunc("/register", registerHandle).Methods("POST")
	r.HandleFunc("/register", registerHandle)

	// Serve and log
	if err := http.ListenAndServe(":"+listenPort, r); err != nil {
		log.Error(err)
		return
	}
}

func ErrorFail(e error) {
	if e != nil {
		log.Fatal(e)
	}
}

func enableCors(w *http.ResponseWriter, req *http.Request) {
	log.Debug("enableCors called")
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
	(*w).Header().Set("Access-Control-Allow-Methods", "POST")
	(*w).Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length")
}

func registerHandle(w http.ResponseWriter, r *http.Request) {
	log.Debug("registerHandle called")
	log.Debug(r.Method)

	enableCors(&w, r)
	if r.Method == "OPTIONS" {
		log.Info("Responding 200 to OPTIONS pre-flight Check")
		w.WriteHeader(200)
		return
	}

	log.Debug(r)
	if body, err := ioutil.ReadAll(r.Body); err != nil {
		log.Error(err)
		return
	}

	defer r.Body.Close()
	var acct Account

	if err = json.Unmarshal(body, &acct); err != nil {
		log.Error(err)
		return
	}

	if hash, err := bcrypt.GenerateFromPassword([]byte(acct.User.Password), 0); err != nil {
		log.Error(err)
		return
	}

	log.Info(fmt.Sprintf("Received FormValues: %s, %s, %s, %b", acct.User.Username,
		acct.User.Email, hash))

	if err = db.InsertNewUser(&acct, hash); err != nil {
		log.Error(err)
		return
	}

	//return 200 + json
}
