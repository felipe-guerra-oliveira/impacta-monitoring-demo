echo "Create Java App"
mvn clean package

echo "Run Java App"
sudo java -jar /opt/simple-api/target/simple-springboot-api-1.0.0.jar &

echo "## End ##"

