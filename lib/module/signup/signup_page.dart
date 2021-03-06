import 'package:flutter/material.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/base/base_widget.dart';
import 'package:flutter_watch_shop_app/data/remote/user_service.dart';
import 'package:flutter_watch_shop_app/data/repo/user_repo.dart';
import 'package:flutter_watch_shop_app/event/signup_event.dart';
import 'package:flutter_watch_shop_app/event/signup_fail_event.dart';
import 'package:flutter_watch_shop_app/event/signup_sucess_event.dart';
import 'package:flutter_watch_shop_app/module/home/home_page.dart';
import 'package:flutter_watch_shop_app/module/signup/signup_bloc.dart';
import 'package:flutter_watch_shop_app/shared/widget/bloc_listener.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      di: [
        Provider.value(value: UserService()),
        ProxyProvider<UserService, UserRepo>(
            update: (context, userService, previous) =>
                UserRepo(userService: userService))
      ],
      bloc: [],
      body: SignUpFormWidget(),
    );
  }
}

class SignUpFormWidget extends StatefulWidget {
  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final TextEditingController _txtNameController = TextEditingController();
  final TextEditingController _txtPhoneController = TextEditingController();

  final TextEditingController _txtEmailController = TextEditingController();

  final TextEditingController _txtPassController = TextEditingController();

  handleEvent(BaseEvent event) {
    if (event is SignUpSuccessEvent) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName('/home'),
      );
      return;
    }

    if (event is SignUpFailEvent) {
      final snackBar = SnackBar(
        content: Text(event.errMessage),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpBloc(userRepo: Provider.of(context)),
      child: Consumer<SignUpBloc>(
        builder: (context, bloc, child) => BlocListener<SignUpBloc>(
          listener: handleEvent,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/watch1.jpg"),
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "SIGN UP",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.account_box,
                                  color: Color(0xFFFFBD73),
                                ),
                              ),
                              Expanded(
                                child: _buildFullNameField(bloc),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.phone,
                                  color: Color(0xFFFFBD73),
                                ),
                              ),
                              Expanded(
                                child: _buildPhoneField(bloc),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.alternate_email,
                                  color: Color(0xFFFFBD73),
                                ),
                              ),
                              Expanded(
                                child: _buildEmailField(bloc),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.lock,
                                  color: Color(0xFFFFBD73),
                                ),
                              ),
                              Expanded(
                                child: _buildPasswordField(bloc),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        _buildSignInButton(bloc),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(SignUpBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 143, 158, 1),
                      Color.fromRGBO(255, 188, 143, 1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: FlatButton(
                onPressed: enable
                    ? () {
                        bloc.event.add(SignUpEvent(
                            fullName: _txtNameController.text,
                            phone: _txtPhoneController.text,
                            email: _txtEmailController.text,
                            pass: _txtPassController.text));
                      }
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Center(
                  child: Text(
                    'Đăng kí',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Netflix",
                      fontWeight: FontWeight.w600,
                      fontSize: 23,
                      letterSpacing: 0.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildPhoneField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.phoneStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextField(
            onChanged: (text) {
              bloc.phoneSink.add(text);
            },
            controller: _txtPhoneController,
            cursorColor: Colors.black,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: "0909 000 999", labelText: "Phone", errorText: msg)),
      ),
    );
  }

  Widget _buildFullNameField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.nameStream,
      child: Consumer<String>(
        builder: (context, msg, childe) => TextField(
            onChanged: (text) {
              bloc.nameSink.add(text);
            },
            controller: _txtNameController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                hintText: "Full Name", labelText: "Full Name", errorText: msg)),
      ),
    );
  }

  Widget _buildEmailField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.emailStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextField(
          onChanged: (text) {
            bloc.emailSink.add(text);
          },
          controller: _txtEmailController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              hintText: "a@gmail.com", labelText: "Email", errorText: msg),
        ),
      ),
    );
  }

  Widget _buildPasswordField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.passStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextField(
          onChanged: (text) {
            bloc.passSink.add(text);
          },
          controller: _txtPassController,
          cursorColor: Colors.black,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            labelText: "Password",
            errorText: msg,
          ),
        ),
      ),
    );
  }
}
