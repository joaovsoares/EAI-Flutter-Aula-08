import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'conversormoeda.dart';
import 'requestapi.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> _chaveFormulario = GlobalKey<FormState>();
  TextEditingController _valorParaConversaoEdit = TextEditingController();
  TextEditingController _cotacaoAtualEdit = TextEditingController();
  String _resultado;
  Future<Map> _futureData;

  void limparCampos() {
    _valorParaConversaoEdit.text = '';
    _cotacaoAtualEdit.text = 'Obtendo cotação atual...';

    setState(() {
      var requestAPI = new RequestAPI();

      _resultado = 'Informe valor para conversão e cotação atual';
      _futureData = requestAPI.obterDados();
    });
  }

  @override
  void initState() {
    super.initState();

    limparCampos();
  }

  void converterMoeda() {
    double valorParaConversao = double.parse(_valorParaConversaoEdit.text);
    double cotacaoAtual = double.parse(_cotacaoAtualEdit.text);
    var conversorMoeda = new ConversorMoeda(valorParaConversao, cotacaoAtual);

    setState(() {
      _resultado = conversorMoeda.converterEmString();
    });
  }

  FloatingActionButton botaoDeCalculo() {
    return FloatingActionButton(
        onPressed: () { 
          if (_chaveFormulario.currentState.validate()) {
            converterMoeda();
          }
        },
        tooltip: 'Calcular',
        child: Icon(Icons.calculate)
    );
  }

  IconButton botaoDeLimpar() {
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {
        limparCampos();
      }
    );
  }

  AppBar appBar(String titulo) {
    return AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          botaoDeLimpar(),
        ],
      );
  }

  TextFormField campoTexto({TextEditingController controller, String mensagemDeErro, String rotulo}) {
    return TextFormField(

      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
      ],
      decoration: InputDecoration(labelText: rotulo),
      controller: controller,
      validator: (text) {
        return text.isEmpty ? mensagemDeErro : null;
      },
    );
  }

  Padding textoResultado() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _resultado,
        textAlign: TextAlign.center,
      ),
    );
  }

  Form formulario() {
    return Form(
      key: _chaveFormulario,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          campoTexto(
            rotulo: 'Valor em R\$:',
            mensagemDeErro: 'Informe o valor para conversão!',
            controller: _valorParaConversaoEdit
          ),
          campoTexto(
            rotulo: 'Cotação do dólar em R\$:',
            mensagemDeErro: 'Informe a cotação atual do dólar!',
            controller: _cotacaoAtualEdit
          ),
          textoResultado(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.title),
      body: FutureBuilder<Map>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var cotacaoDolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
            _cotacaoAtualEdit.text = cotacaoDolar.toString();

            return SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: formulario()
            );
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          else {
            return Center(
              child: CircularProgressIndicator()
            );
          }
        },
      ),
      floatingActionButton: botaoDeCalculo(),
    );
  }
}