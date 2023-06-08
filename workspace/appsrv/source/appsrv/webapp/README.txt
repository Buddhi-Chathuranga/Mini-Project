MDAHSE, 2020-06-22

These webapps are not built automatically. You need to build one from
the content of each sub folder here (probably there will only be one,
named appsrv, here, but more can be added later).

The process is quite simple:

For each sub folder here, zip together the war sub folder into a file
with the same name as the sub folder. For example, the content of the
appsrv/war sub folder should be zipped to a file named appsrv.war and
it should have the following contents:

+---config
|       server.xml
\---war
    |   aurena-map.html
    |   aurena-map.js
    |   aurena-plugin-service.js
    +---symbols
    |       BlackCircleLargeB.png
    |       BlackDiamondLargeB.png
    |       BlackPin1LargeB.png
    |       BlackPin2LargeB.png
    |       BlackSquareLargeB.png
    |       BlackStarLargeB.png
    |       BlueCircleLargeB.png
    |       BlueDiamondLargeB.png
    |       BluePin1LargeB.png
    |       BluePin2LargeB.png
    |       BlueSquareLargeB.png
    |       BlueStarLargeB.png
    |       GreenCircleLargeB.png
    |       GreenDiamondLargeB.png
    |       GreenPin1LargeB.png
    |       GreenPin2LargeB.png
    |       GreenSquareLargeB.png
    |       GreenStarLargeB.png
    |       OrangeCircleLargeB.png
    |       OrangeDiamondLargeB.png
    |       OrangePin1LargeB.png
    |       OrangePin2LargeB.png
    |       OrangeSquareLargeB.png
    |       OrangeStarLargeB.png
    |       PurpleCircleLargeB.png
    |       PurpleDiamondLargeB.png
    |       PurplePin1LargeB.png
    |       PurplePin2LargeB.png
    |       PurpleSquareLargeB.png
    |       PurpleStarLargeB.png
    |       RedCircleLargeB.png
    |       RedDiamondLargeB.png
    |       RedPin1LargeB.png
    |       RedPin2LargeB.png
    |       RedSquareLargeB.png
    |       RedStarLargeB.png
    |       YellowCircleLargeB.png
    |       YellowDiamondLargeB.png
    |       YellowPin1LargeB.png
    |       YellowPin2LargeB.png
    |       YellowSquareLargeB.png
    |       YellowStarLargeB.png
    |       
    \---WEB-INF
        |   web.xml
        \---classes <-- this folder is empty

Above, the exact contents of the WAR file may differ as we might add
or remove JavaScript code, for example.

There should be no extra sub folder inside the zip file above. The
JavaScript files are placed in the root. The WEB-INF folder however is
a sub folder and have at least an web.xml file in it.

When the zip file is created, change the extension from .zip to .war.

Each war, plus the server.xml file under the config folder should be
included in the ifsapp-application-svc container. In the container
rename the server.xml file as WEBAPP_server.xml, for example
appsrv_server.xml.

Here are the current instructions (from Prabha Ranaweera) on how to
get the new web app part of ifsapp-application-svc:

  You can commit your war (appsrv.war) to:
  
  https://bitbucket.org/ifs-pd/ifs-technology-applicationplatform-base/src/master/ifs/ifsapp-application-svc/dropins/
  
  and the server.xml (with a non conflicting name) to
  
  https://bitbucket.org/ifs-pd/ifs-technology-applicationplatform-base/src/master/ifs/ifsapp-application-svc/config/.

  Then assign a PR to Prabha or Henrik Hansson

  We will approve and merge the PR and our pipeline will build a new
  image and push to the image repo. Then based on our release cadence
  the new image will be released to the GH environments.

