 "InstanceSecurityGroup" : {
      "Type" : "AWS::EC2::SecurityGroup",
      "Properties" : {
        "GroupDescription" : "Enable HTTP access",
        "VpcId" : { "Ref" : "VPC" },
        "SecurityGroupIngress" : [ { "IpProtocol" : "tcp", "FromPort" : "22", "ToPort" : "22", "CidrIp" : "0.0.0.0/0"},
                                   { "IpProtocol" : "tcp", "FromPort" : "80", "ToPort" : "80", "CidrIp" : "0.0.0.0/0"} ],
        "Tags" : [
        {"Key": "Name", "Value": "Project_EC2_sg"}
         ]
      }},

      "Instance" : {
      "Type" : "AWS::EC2::Instance",
      "Properties" : {
        "KeyName" : { "Ref" : "KeyName" },
        "InstanceType" : { "Ref" : "InstanceType" },
        "ImageId" : { "Fn::FindInMap" : [ "InstanceAMI", { "Ref" : "AWS::Region" },
                                          { "Fn::FindInMap" : [ "AWSInstanceType2Arch", { "Ref" : "InstanceType" },
                                          "Arch" ] } ] },
                                          "NetworkInterfaces" : [
                                            { "DeviceIndex" : "0",
                                              "AssociatePublicIpAddress" : "true",
                                              "DeleteOnTermination" : "true",
                                              "SubnetId" : { "Ref" : "PublicSubnet" },
                                              "GroupSet" : [ { "Ref" : "InstanceSecurityGroup" } ]
                                            }
                                          ],
        "Tags" : [
        {"Key": "Name", "Value": "Project_Instance"}
         ],
         "UserData"       : { "Fn::Base64" : { "Fn::Join" : ["", [
      "#!/bin/bash -ex\n",
      "apt-get update"
    ]]}}
      }},

"Outputs" : {
 "InstanceId" : {
 "Description" : "InstanceId of the newly created Mysql instance",
 "Value" : { "Ref" : "Instance" }
 },
 "WebUrl" : {
 "Description" : "This is the endpoint of application.",
 "Value" : { "Fn::Join" : [ "", [ "https://", { "Fn::GetAtt" : [ "Instance", "PublicIp"] } , ":8444" ] ] }
 }
 