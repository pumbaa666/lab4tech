Title
===

Overview
---
For now i store everything here.





Blue-Green Deployment
---

https://youtu.be/ekh2uW1VU6U?list=PLzde74P_a04cpN1pEerB0szRAbn38JKWT&t=456

All-at-once
Linear (10% / 1 or 3 minute)
Canary (10% puis tout le reste après 5 min)

ECS Cluster Auto Scaling
---

AGS : Auto Scalling Group

https://youtu.be/0j8D-be2J1k?list=PLzde74P_a04cpN1pEerB0szRAbn38JKWT&t=94

An alarm is triggered (a metric indicates a resource is almost at capacity (memory, cpu, ...))
ASG gets notified by CloudWatch
which create and launch some new container instances 

DynamoDB Streams
---

https://youtu.be/_D2Uiufn7NA?list=PLzde74P_a04cpN1pEerB0szRAbn38JKWT&t=161


VPC, NAT private and public subnet
---

(question d'exam)
https://youtu.be/beV1AYyhgYA?list=PLzde74P_a04cpN1pEerB0szRAbn38JKWT&t=100


Create Simple Hello-World with AWS Serverless Application Model (SAM)
---

https://www.youtube.com/watch?v=5HvEeAtmiHI


ECS, ECR, Fargate
---

Cheat sheet : https://youtu.be/RrKRN9zRBWs?t=10495


X-Ray
---

https://youtu.be/RrKRN9zRBWs?t=10547
Cheat sheet : https://youtu.be/RrKRN9zRBWs?t=12134

KMS : Key Management Service
---

https://youtu.be/RrKRN9zRBWs?t=14690
Une checkbox pour crypter ? --> KMS

HSM : https://youtu.be/RrKRN9zRBWs?t=14761


Cognito
---

https://youtu.be/RrKRN9zRBWs?t=15272

Cognito Sync (uses SNS) : https://youtu.be/RrKRN9zRBWs?t=15594


SNS
---

SMS, email, webhooks, lambdas, SQS, mobile notif
https://youtu.be/RrKRN9zRBWs?t=15991


SQS
---

Type of queue (Standards vs FIFO) : https://youtu.be/RrKRN9zRBWs?t=16759
Visibility (messages can be read twice) : https://youtu.be/RrKRN9zRBWs?t=16902
Long polling vs Short polling (Long (not default !!) reduce the number of empty response) : https://youtu.be/RrKRN9zRBWs?t=16915
