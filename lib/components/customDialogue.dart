import 'package:flutter/material.dart';

class CustomDialogue extends StatefulWidget {
  final String title, message;
  final bool cancel ;
  final IconData icon;
  final Function onClick;

  CustomDialogue({this.title, this.message, this.icon, this.onClick, this.cancel});

  @override
  _CustomDialogueState createState() => _CustomDialogueState();
}

class _CustomDialogueState extends State<CustomDialogue> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(5),
        height: 230,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        widget.icon,
                        size: 45,
                      ),
                      Text(
                        widget.message,
                        style:
                            TextStyle(fontSize: 22, color: Colors.green[300]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     InkWell(
                      child: widget.cancel ? Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: Text(
                          "Annuler",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ) ,
                      ) : Container(),
                      onTap: () => Navigator.pop(context),
                    ),
                    Spacer(),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: Text(
                          "OK",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,

                          ),
                        ),
                      ),
                      onTap: () => widget.onClick(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
