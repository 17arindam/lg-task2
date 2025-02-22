class KML2 {
  static const String kml = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2"
     xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <name>Himalayan Peaks Tour</name>
    <description>An interactive tour of major Himalayan peaks with orbital views</description>

    <!-- Styles for placemarks -->
    <Style id="mountain_style">
      <IconStyle>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/shapes/mountains.png</href>
        </Icon>
      </IconStyle>
    </Style>

    <!-- Google Earth Tour -->
    <gx:Tour>
      <name>Himalayan Peaks Tour</name>
      <gx:Playlist>
        <!-- Mount Everest -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>86.9250</longitude>
            <latitude>27.9881</latitude>
            <altitude>12000</altitude>
            <heading>0</heading>
            <tilt>70</tilt>
            <range>5000</range>
          </LookAt>
        </gx:FlyTo>
        
        <gx:Wait>
          <gx:duration>5.0</gx:duration>
        </gx:Wait>

        <!-- K2 -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>76.5133</longitude>
            <latitude>35.8825</latitude>
            <altitude>10000</altitude>
            <heading>45</heading>
            <tilt>60</tilt>
            <range>6000</range>
          </LookAt>
        </gx:FlyTo>
        
        <gx:Wait>
          <gx:duration>5.0</gx:duration>
        </gx:Wait>

        <!-- Kangchenjunga -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <gx:flyToMode>bounce</gx:flyToMode>
          <LookAt>
            <longitude>88.1475</longitude>
            <latitude>27.7025</latitude>
            <altitude>9000</altitude>
            <heading>90</heading>
            <tilt>65</tilt>
            <range>6000</range>
          </LookAt>
        </gx:FlyTo>
        
        <gx:Wait>
          <gx:duration>5.0</gx:duration>
        </gx:Wait>

        <!-- Activate tour -->
        <gx:TourControl>
          <gx:playMode>play</gx:playMode>
        </gx:TourControl>
      </gx:Playlist>
    </gx:Tour>

    <!-- Placemarks -->
    <Placemark>
      <name>Mount Everest</name>
      <description>Height: 8,848 m (29,029 ft)</description>
      <styleUrl>#mountain_style</styleUrl>
      <Point>
        <coordinates>86.9250,27.9881,8848</coordinates>
      </Point>
    </Placemark>

    <Placemark>
      <name>K2</name>
      <description>Height: 8,611 m (28,251 ft)</description>
      <styleUrl>#mountain_style</styleUrl>
      <Point>
        <coordinates>76.5133,35.8825,8611</coordinates>
      </Point>
    </Placemark>

    <Placemark>
      <name>Kangchenjunga</name>
      <description>Height: 8,586 m (28,169 ft)</description>
      <styleUrl>#mountain_style</styleUrl>
      <Point>
        <coordinates>88.1475,27.7025,8586</coordinates>
      </Point>
    </Placemark>
  </Document>
</kml>
''';
}
