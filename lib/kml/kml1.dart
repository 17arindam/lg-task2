class KML1 {
  static const String kml = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <name>Seven Wonders Tour</name>
    <open>1</open>

    <gx:Tour>
      <name>World Wonders Tour</name>
      <gx:Playlist>

        <!-- Taj Mahal -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>78.0418727</longitude>
            <latitude>27.1744287</latitude>
            <altitude>182.0789411</altitude>
            <heading>0.0323890</heading>
            <tilt>61.9010861</tilt>
            <range>538.5527982</range>
          </LookAt>
        </gx:FlyTo>
        <gx:Wait>
          <gx:duration>6.0</gx:duration>
        </gx:Wait>
        <Placemark>
          <name>Taj Mahal</name>
          <ExtendedData>
            <Data name="wait_duration">
              <value>11.0</value>
            </Data>
          </ExtendedData>
          <Point><coordinates>78.0421323,27.1750488,0</coordinates></Point>
        </Placemark>

        <!-- Great Wall of China -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>117.2361</longitude>
            <latitude>40.6769</latitude>
            <altitude>200</altitude>
            <heading>0</heading>
            <tilt>45</tilt>
            <range>1000</range>
          </LookAt>
        </gx:FlyTo>
        <gx:Wait>
          <gx:duration>6.0</gx:duration>
        </gx:Wait>
        <Placemark>
          <name>Great Wall of China</name>
          <ExtendedData>
            <Data name="wait_duration">
              <value>11.0</value>
            </Data>
          </ExtendedData>
          <Point><coordinates>117.2361,40.6769,0</coordinates></Point>
        </Placemark>

        <!-- Petra -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>35.4444</longitude>
            <latitude>30.3285</latitude>
            <altitude>150</altitude>
            <heading>10</heading>
            <tilt>45</tilt>
            <range>1200</range>
          </LookAt>
        </gx:FlyTo>
        <gx:Wait>
          <gx:duration>6.0</gx:duration>
        </gx:Wait>
        <Placemark>
          <name>Petra</name>
          <ExtendedData>
            <Data name="wait_duration">
              <value>11.0</value>
            </Data>
          </ExtendedData>
          <Point><coordinates>35.4444,30.3285,0</coordinates></Point>
        </Placemark>

        <!-- Colosseum -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>12.4924</longitude>
            <latitude>41.8902</latitude>
            <altitude>100</altitude>
            <heading>0</heading>
            <tilt>45</tilt>
            <range>800</range>
          </LookAt>
        </gx:FlyTo>
        <gx:Wait>
          <gx:duration>6.0</gx:duration>
        </gx:Wait>
        <Placemark>
          <name>Colosseum</name>
          <ExtendedData>
            <Data name="wait_duration">
              <value>11.0</value>
            </Data>
          </ExtendedData>
          <Point><coordinates>12.4924,41.8902,0</coordinates></Point>
        </Placemark>

        <!-- Christ the Redeemer -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>-43.2105</longitude>
            <latitude>-22.9519</latitude>
            <altitude>200</altitude>
            <heading>0</heading>
            <tilt>45</tilt>
            <range>1000</range>
          </LookAt>
        </gx:FlyTo>
        <gx:Wait>
          <gx:duration>6.0</gx:duration>
        </gx:Wait>
        <Placemark>
          <name>Christ the Redeemer</name>
          <ExtendedData>
            <Data name="wait_duration">
              <value>11.0</value>
            </Data>
          </ExtendedData>
          <Point><coordinates>-43.2105,-22.9519,0</coordinates></Point>
        </Placemark>

        <!-- Machu Picchu -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>-72.5450</longitude>
            <latitude>-13.1631</latitude>
            <altitude>250</altitude>
            <heading>0</heading>
            <tilt>45</tilt>
            <range>1200</range>
          </LookAt>
        </gx:FlyTo>
        <gx:Wait>
          <gx:duration>6.0</gx:duration>
        </gx:Wait>
        <Placemark>
          <name>Machu Picchu</name>
          <ExtendedData>
            <Data name="wait_duration">
              <value>11.0</value>
            </Data>
          </ExtendedData>
          <Point><coordinates>-72.5450,-13.1631,0</coordinates></Point>
        </Placemark>

        <!-- Chichen Itza -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>-88.5678</longitude>
            <latitude>20.6843</latitude>
            <altitude>200</altitude>
            <heading>0</heading>
            <tilt>45</tilt>
            <range>1000</range>
          </LookAt>
        </gx:FlyTo>
        <gx:Wait>
          <gx:duration>6.0</gx:duration>
        </gx:Wait>
        <Placemark>
          <name>Chichen Itza</name>
          <ExtendedData>
            <Data name="wait_duration">
              <value>11.0</value>
            </Data>
          </ExtendedData>
          <Point><coordinates>-88.5678,20.6843,0</coordinates></Point>
        </Placemark>

      </gx:Playlist>
    </gx:Tour>
  </Document>
</kml>''';
}
