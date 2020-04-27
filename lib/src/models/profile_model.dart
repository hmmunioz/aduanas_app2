
 class ProfileModel {
      String _usuarioUUID;
      String _nombre;
      String _correo;
      String _telefono;    


  ProfileModel(this._usuarioUUID, this._nombre, this._correo, this._telefono);
 
  factory ProfileModel.fromJson(Map<String, dynamic> data) {
    return new ProfileModel(
        data['usuarioUUID'],
        data['nombre'],
        data['correo'],
        data['telefono']);
  }
   ProfileModel.fromDb(Map<String, dynamic> parsedJson):
       _usuarioUUID = parsedJson['usuarioUUID'],
       _nombre =  parsedJson['nombre'],
       _correo= parsedJson['correo'],     
       _telefono=  parsedJson['correo'];

  Map<String, dynamic> toJson() => {
        'usuarioUUID': getUsuarioUUID,
        'nombre': getNombre,
        'correo': getCorreo,     
        'telefono': getTelefono
      };

  String get getUsuarioUUID => _usuarioUUID;
  String get getNombre => _nombre;
  String get getCorreo => _correo;
  String get getTelefono => _telefono;

 
  
}
