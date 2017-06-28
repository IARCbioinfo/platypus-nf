cd ~/platypus-nf/
git config --global user.email "delhommet@students.iarc.fr"
git add dag*
git commit -m "Generated DAG [skip ci]"
git push origin $CIRCLE_BRANCH

curl -H "Content-Type: application/json" --data "{\"source_type\": \"Branch\", \"source_name\": \"$CIRCLE_BRANCH\"}" -X POST https://registry.hub.docker.com/u/iarcbioinfo/platypus-nf/trigger/c910ef0f-0d57-4ccd-9fb0-efd03108e5a3/
