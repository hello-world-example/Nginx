# Nginx 

空的模版项目

- cp -r Nginx <NewProject>
- cd <NewProject>
- rm Nginx.iml
- sed -i '' 's/Nginx/<NewProject>/g' `grep Nginx --include=\*.{md,html,xml} -rl .`
- git remote set-url origin https://github.com/hello-world-example/<NewProject>.git

