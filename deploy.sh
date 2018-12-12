cd ~/project/
commitID=`git log -n 1 --pretty="%h" -- environment.yml`
sed -i '/^# environment.yml/d' Singularity && echo -e "\n# environment.yml commit ID: $commitID\n" >> Singularity
git config --global user.email "delhommet@students.iarc.fr"
git config --global user.name "Circle CI_$CIRCLE_PROJECT_REPONAME_$CIRCLE_BRANCH"
git pull
git add dag*
git commit -m "Generated DAG [skip ci]"
git push origin $CIRCLE_BRANCH

curl -H "Content-Type: application/json" --data "{\"source_type\": \"Branch\", \"source_name\": \"$CIRCLE_BRANCH\"}" -X POST https://registry.hub.docker.com/u/iarcbioinfo/platypus-nf/trigger/c910ef0f-0d57-4ccd-9fb0-efd03108e5a3/
