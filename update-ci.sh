cat << EOF > .gitlab-ci.yml
image: docker:latest

before_script:
  - docker login -u gitlab-ci-token -p \$CI_JOB_TOKEN \$CI_REGISTRY

EOF

for dir in *; do
	if [ -d "$dir" ]; then
		cat << EOF >> .gitlab-ci.yml
build_$dir:
  stage: build
  only:
    - master
  script:
    - cd $dir
    - docker build --pull -t "\$CI_REGISTRY_IMAGE:$dir" .
    - docker push "\$CI_REGISTRY_IMAGE:$dir"

EOF
	fi
done
