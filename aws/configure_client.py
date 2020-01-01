"""Configures the client with endpoints and Cognito outputs"""

from typing import Dict
import boto3


def write_amplify_config(stack: Dict):
    """Configure the client with Cognito outputs"""
    try:
        config = {}
        for output in stack['Outputs']:
            if output['OutputKey'] == 'UserPoolOutput':
                config['user_pool_id'] = output['OutputValue']

            if output['OutputKey'] == 'UserPoolClientOutput':
                config['user_pool_web_client_id'] = output['OutputValue']

        with open('../client/aws/aws-exports.js', 'w') as config_file:
            config_file.write(
                'export const awsconfig = {\n'
                '  region: "us-west-2",\n'
                f'  userPoolId: "{config["user_pool_id"]}",\n'
                f'  userPoolWebClientId: "{config["user_pool_web_client_id"]}"\n'
                '};'
            )
    except KeyError as ex:
        print('The stack was not configured properly. A {} key could not be found'.format(ex))

if __name__ == '__main__':
    cloudformation = boto3.client('cloudformation', region_name='us-west-2')
    stacks = cloudformation.describe_stacks(StackName='LunarRocksStack')

    try:
        stack = stacks['Stacks'][0]
        write_amplify_config(stack)

    except KeyError:
        print('Stack does not exist')
