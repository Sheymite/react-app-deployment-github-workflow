FROM node:18 as build  

#set the working directory inside the container
WORKDIR /app

#copy package.json and package-lock.json files to the working directory
COPY package*.json ./

#install the dependencies
RUN npm install  

#copy the rest of the application code to the rest of the working directory
COPY . .

#build the react application
RUN npm run build

#stage 2 serve the react application with nginx
FROM nginx:alpine

#COPY the build file from the previous stage to nginx directory
COPY --from=build /app/build /usr/share/nginx/html

#copy the nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

#EXPOSE port 80 to the outside world
EXPOSE 80

# Start Nginx 
CMD ["nginx", "-g", "daemon off;"]