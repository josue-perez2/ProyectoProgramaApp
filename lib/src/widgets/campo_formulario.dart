import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoFormulario extends StatefulWidget {
  const CampoFormulario({
    super.key,
    required this.controller,
    required this.etiqueta,
    required this.icono,
    this.textoSecreto = false,
    this.teclado,
    this.maxLength,
    this.sugerencia,
    this.validator,
    this.onChanged,
    this.formatters = const <TextInputFormatter>[],
  });

  final TextEditingController controller;
  final String etiqueta;
  final IconData icono;
  final bool textoSecreto;
  final TextInputType? teclado;
  final int? maxLength;
  final String? sugerencia;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  final List<TextInputFormatter> formatters;

  @override
  State<CampoFormulario> createState() => _CampoFormularioState();
}

class _CampoFormularioState extends State<CampoFormulario> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.textoSecreto && _oculto,
      keyboardType: widget.teclado,
      maxLength: widget.maxLength,
      validator: widget.validator,
      onChanged: widget.onChanged,
      inputFormatters: widget.formatters.isNotEmpty
          ? widget.formatters
          : widget.maxLength == null
          ? null
          : <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(widget.maxLength),
            ],
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        hintText: widget.sugerencia,
        prefixIcon: Icon(widget.icono),
        counterText: '',
        suffixIcon: widget.textoSecreto
            ? IconButton(
                tooltip: _oculto ? 'Mostrar' : 'Ocultar',
                onPressed: () => setState(() => _oculto = !_oculto),
                icon: Icon(
                  _oculto ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
              )
            : null,
      ),
    );
  }
}
