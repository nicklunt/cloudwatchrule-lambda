#!/usr/bin/env python3

import boto3
import collections
import datetime

region = "eu-west-2"
retentionDays = 14

filter_tag_owner = ['nickl']
filter_tag_contact = ['*ick.Lunt*']

ec = boto3.client('ec2', region)

def lambda_handler(event, context):
  GetInstances()


def CreateSnapshot(vol_to_snap, vol_details, instance_details):
  today = datetime.datetime.today()
  expirationDate = datetime.datetime.today() + datetime.timedelta(days=retentionDays)

  for tags in instance_details['Tags']:
    if tags['Key'] in ['name', 'Name', 'NAME']:
      tname = "nl-{}".format(tags['Value'])
      snapshot_name = tname
    else:
      snapshot_name = "nl"

  v = ec.describe_volumes(VolumeIds=[vol_to_snap])

  for r in v['Volumes']:
    if 'Tags' in r.keys():
      for tags in r['Tags']:
        if tags['Key'] in ['name', 'Name', 'NAME']: # The tags need to be decided upon and set in TF.
          volume_name = tags['Value']
        else:
          volume_name = "NA"

        if tags['Key'] in ['backup', 'Backup'] and tags['Value'] in ['yes', 'YES', 'Yes', 'true', 'TRUE', 'True']: # The tags need to be decided upon and set in TF.
          description = "Instance Name:{}\nInstance ID:{}\nVolume Name:{}\nSource VolumeID:{}\nSource Device Name:{}\nCreated:{}".format(snapshot_name, instance_details['InstanceId'], volume_name, vol_to_snap, vol_details['DeviceName'], today)
          print("Creating snapshot from source volume {}".format(vol_to_snap))
          print(description)
          
          response = ec.create_snapshot(
            Description = description,
            VolumeId = vol_to_snap,
            TagSpecifications = [
              {
                'ResourceType': 'snapshot',
                'Tags': 
                  [
                    {
                      'Key': 'SnapshotName',
                      'Value': snapshot_name
                    },
                    {
                      'Key': 'InstanceID',
                      'Value': instance_details['InstanceId']
                    },
                    {
                      'Key': 'SourceVolumeID',
                      'Value': vol_to_snap
                    },
                    {
                      'Key': 'DeviceName',
                      'Value': vol_details['DeviceName']
                    },
                    {
                      'Key': 'Created',
                      'Value': str(today)
                    },
                    {
                      'Key': 'SourceVolumeName',
                      'Value': volume_name
                    },
                    {
                      'Key': 'ExpirationDate',
                      'Value': str(expirationDate)
                    },
                    {
                      'Key': 'Owner',
                      'Value': 'LECP'
                    },
                  ]
                },
              ],
              DryRun=False
            )
          print("Snapshot created from source volume {}".format(vol_to_snap))
      
def GetVolumes(instance):
  for vol in instance['BlockDeviceMappings']:
    vol_id = vol['Ebs']['VolumeId']
    CreateSnapshot(vol_id, vol, instance)

# The tags need to be decided upon and set in TF at the top of this script.
def GetInstances():
  reservations = ec.describe_instances(
    Filters = [
      {
        'Name':'tag:owner',
        'Values': filter_tag_owner
      },
      {
        'Name': 'tag:OwnerContact',
        'Values': filter_tag_contact
      }
    ]
  ).get('Reservations',[])

  instances = sum([[i for i in r['Instances']] for r in reservations], [])

  for instance in instances:
    GetVolumes(instance)


# if __name__ == '__main__':
#   GetInstances()