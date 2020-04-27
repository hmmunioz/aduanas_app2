class AppConfig { 
final String base_url ="http://192.168.5.118:9090/api/v1/"; 
//  final String base_url ="http://201.234.201.170:1095/web/v1/"; 
  final int timeout =20;   
 
  dynamic notificationChannels={
    'id' :'ntf_channel',
     'name': 'tramitesChannel', 
     'description':'Alert to Tramites', 
  };

}