# Private Registry

To pull the image from the private registry with Kubernetes it is necessary to create secret and use secret while pulling the images from the private registry. 

# Create the Secret 

To create the secret with kubectl command line utility: 
```
kubectl create secret docker-registry regsecret --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
```

### Example
If you are using the private dockerhub image, then it is necessary that Kubernetes manifests should authenticate with registry server using secrets. 

For  Dockerhub,
```
kubectl create secret docker-registry regsecret --docker-server=https://index.docker.io/v1/ --docker-username=kubejack --docker-password=voya@Password123 --docker-email=jakirpatel@outlook.com
```

For Dockerhub, 
  - Registry server is : https://index.docker.io/v1/
  - Docker username: It should be the username of your dockerhub account. In my example it is `kubejack`.
  - Docker Password: It is the password of the account. The password should be the valid passowrd for the username. 
  - Docker Email: This is the email registered with Dockerhub account. 

# Using Secret while pulling the image
In declarative approach `ImagePullSecrets` key is used for authenticating Kubernetes to pull the private images from the registry. 

Example: 
deployment.yaml
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-world
  labels:
    app: hello-world
    ver: v1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world
      ver: v1
  template:
    metadata:
      labels:
        app: hello-world
        ver: v1
    spec:
      containers:
      - name: hello-world
        image: kubejack/hello-world-private:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 3000

      imagePullSecrets:
      - name: regsecret

```

here `regsecret` is the secret used for authenticating Kubernetes pulling the private Dockerhub image `kubejack/hello-world-private:latest`.

This is the way you can create the secret and use the private images from registry with Kubernetes. 
