import 'package:flutter/material.dart';
// Importa el mapa de colores definidio para la aplicación
import 'package:priori_dev/src/colors/colores.dart';

// Definición del callback realizado desde la instanciación de esta clase
typedef callbackFunc = Map Function(Map);

class NuevoArticuloPage extends StatefulWidget {
  // Argumentos para la instancia de la clase
  final Map<int, Map<String, dynamic>> compras;
  final callbackFunc callback;
  final Map<String, dynamic> articulo;
  // Constructor
  NuevoArticuloPage({
    Key key,
    @required this.compras,
    @required this.callback,
    this.articulo,
  }) : super(key: key);
  // Creación de estado
  @override
  _NuevoArticuloPageState createState() => _NuevoArticuloPageState();
}

class _NuevoArticuloPageState extends State<NuevoArticuloPage> {
  // Variables de los input
  int _prioridad;
  // Controladores para la carga automática de valores en caso que
  // se deseé editar un artículo
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialización de valores para la actualización
    // Condición: Si existe un artículo para actualizar mandado a llamar desde
    // la instanciación de la clase, entonces el controlador tomará el valor
    // correspondiente a la propiedad. En caso contrario, quedará vacío.
    _nombreCtrl.text = widget.articulo != null ? widget.articulo['nombre'] : '';
    _descCtrl.text =
        widget.articulo != null ? widget.articulo['descripcion'] : '';
    _precioCtrl.text =
        widget.articulo != null ? widget.articulo['precio'].toString() : '';
    _prioridad = widget.articulo != null ? widget.articulo['prioridad'] : 1;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descCtrl.dispose();
    _precioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Construcción del Scaffold
    return Scaffold(
      appBar: AppBar(
          backgroundColor: getColor('fondo'),
          title: Text(widget.articulo != null
              ? widget.articulo['nombre']
              : 'Nuevo articulo'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.edit, color: getColor('texto')),
                onPressed: () {})
          ],
          iconTheme: IconThemeData(color: getColor('texto')),
          elevation: 0.0),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: _crearContenidoLista(), // Contenido del scaffold
      ),
    );
  }

  // Crea el contenido de la lista mostrada en el scaffold
  List<Widget> _crearContenidoLista() {
    return <Widget>[
      _crearLabel('Nombre'),
      SizedBox(height: 15.0),
      _crearInput('nombre', _nombreCtrl),
      SizedBox(height: 20.0),
      _crearLabel('Descicpción'),
      SizedBox(height: 15.0),
      _crearInput('descripcion', _descCtrl),
      SizedBox(height: 20.0),
      _crearLabel('Precio'),
      SizedBox(height: 15.0),
      _crearInput('precio', _precioCtrl),
      SizedBox(height: 20.0),
      _crearLabel('Prioridad'),
      SizedBox(height: 15.0),
      _crearInputPrioridad(),
      SizedBox(height: 45.0),
      Row(
        children: <Widget>[
          FlatButton(
            child: Text('Cancelar'),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            textColor: getColor('texto'),
            shape: StadiumBorder(),
            onPressed: () {
              // Cuando es pulsado, se sale de la página
              Navigator.pop(context);
            },
          ),
          Expanded(child: SizedBox()),
          RaisedButton(
            child: Text('Guardar'),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            color: getColor('principal'),
            textColor: Colors.white,
            elevation: 0,
            shape: StadiumBorder(),
            onPressed: () {
              // Llama el calback definido como un argumento y pasa un mapa con
              // llaves de cadena y valores dinámicos. Es decir, pasa el
              // artículo que se haya definido en los input
              widget.callback(<String, dynamic>{
                'nombre': _nombreCtrl.text,
                'descripcion': _descCtrl.text,
                'precio': _precioCtrl.text,
                'prioridad': _prioridad
              });
              // Se sale de la página
              Navigator.pop(context);
            },
          ),
        ],
      )
    ];
  }

  // Crea el "input" para incrementar o decrementar la prioridad
  Widget _crearInputPrioridad() {
    return Row(
      children: <Widget>[
        // Botón -
        ButtonTheme(
          minWidth: 50,
          height: 50,
          child: RaisedButton(
            padding: EdgeInsets.all(0),
            elevation: 0,
            child: Icon(Icons.remove),
            color: getColor('principal'),
            shape: StadiumBorder(),
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                // Decrementa el estado de la prioridad con un tope de 1
                if (_prioridad == 1)
                  _prioridad = 1;
                else
                  _prioridad--;
              });
            },
          ),
        ),
        // Contenedor que simula un input
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17.0),
            ),
            child: Center(
              child: Text(_prioridad.toString()),
            ),
          ),
        ),
        // Botón +
        ButtonTheme(
          minWidth: 50,
          height: 50,
          child: RaisedButton(
            padding: EdgeInsets.all(0),
            elevation: 0,
            child: Icon(Icons.add),
            color: getColor('principal'),
            shape: StadiumBorder(),
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                // Incrementa el estado de la prioridad con un tope de 10
                if (_prioridad == 10)
                  _prioridad = 10;
                else
                  _prioridad++;
              });
            },
          ),
        ),
      ],
    );
  }

  // Crea los Textos que aparecen por encima de los input
  Widget _crearLabel(texto) {
    return Text(texto,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  // Crea los input o cajas de texto
  Widget _crearInput(tipo, control) {
    return TextField(
      controller:
          control, // carga los datos definidos por el controlador. Recuerde que si es un artículo nuevo, se cargará una cadena vacía, pero si es un artículo para editar, cargará el dato correspondiente.

      keyboardType: // Define el tipo de caja de texto que se va a dibujar
          tipo == 'precio' ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 10.0),
        // Propiedades del borde
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
          borderSide: BorderSide(color: getColor('inputBorder'), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
          borderSide: BorderSide(color: Colors.white, width: 0),
        ),
        labelStyle: TextStyle(color: getColor('inputLabel')),
        // Para el fondo
        isDense: true,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
