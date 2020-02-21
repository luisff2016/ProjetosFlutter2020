import "package:flutter/material.dart";


/// ********************************************************************************************************************
/// The Notes screen.
/// ********************************************************************************************************************
class Teste extends StatelessWidget {


  /// Constructor.
  Teste() {

    print("##200 Teste ok ");

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##201 Teste.build()");

    return Scaffold(
      appBar: AppBar(
        title: Text("Em teste!!${inContext.hashCode}"),
      ),
      ); 
  } /* End build(). */


} /* End class. */
