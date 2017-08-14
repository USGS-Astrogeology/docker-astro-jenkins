# Docker-Astro-Jenkins

Repository for astro's jenkins ci

If you use [Docker-Jenkinsdata](https://github.com/USGS-Astrogeology/docker-jenkinsdata) for persistence you should run this with:

```
docker run --name jenkins-data usgsastro/jenkinsdata
docker run -p 8080:8080 -p 50000:50000 --name=jenkins --volumes-from=jenkins-data -d usgsastro/jenkins
```
