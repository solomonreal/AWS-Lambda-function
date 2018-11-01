import boto3
ec2 = boto3.resource('ec2')

def lambda_handler(event, context):
    filters = [{
            'Name': 'tag:Automatically switch on in morning',
            'Values': ['Yes']
        },
        {
            'Name': 'instance-state-name', 
            'Values': ['stopped']
        }
    ]
    
    instances = ec2.instances.filter(Filters=filters)

    stoppedInstances = [instance.id for instance in instances]
    
    if len(stoppedInstances) > 0:
        start_instances = ec2.instances.filter(InstanceIds=stoppedInstances).start()
