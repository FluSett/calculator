import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import './theme.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
          builder: (context, ThemeNotifier themeNotifier, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Calculator',
              theme: themeNotifier.darkTheme ? darkTheme : lightTheme,
              home: const MyApp(),
            );
          },
        ),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int brackets = 0;
  double expressionFontSize = 70;
  bool isDot = false;
  bool isResult = false;
  bool isNext = false;

  String expression = '';
  String hintExpression = '';

  final ScrollController _controller = ScrollController();

  _openGit() async {
    const url = 'https://github.com/FluSett/calculator';
    await launch(url);
  }

  bool isDigit(int num) {
    return (getLastCharacter(num) == '0' ||
        getLastCharacter(num) == '1' ||
        getLastCharacter(num) == '2' ||
        getLastCharacter(num) == '3' ||
        getLastCharacter(num) == '4' ||
        getLastCharacter(num) == '5' ||
        getLastCharacter(num) == '6' ||
        getLastCharacter(num) == '7' ||
        getLastCharacter(num) == '8' ||
        getLastCharacter(num) == '9');
  }

  bool isOperation(int num) {
    return (getLastCharacter(num) == '+' ||
        getLastCharacter(num) == '-' ||
        getLastCharacter(num) == '*' ||
        getLastCharacter(num) == '/');
  }

  String getLastCharacter(int num) {
    if (expression.isNotEmpty && num == 1) {
      return expression[expression.length - 1];
    } else if (expression.length > 1 && num == 2) {
      return expression[expression.length - 2];
    } else {
      return '';
    }
  }

  void deleteLatest() {
    if (expression.isNotEmpty) {
      if (getLastCharacter(1) == ')') {
        setState(() {
          expression = expression.substring(0, expression.length - 1);
          brackets++;
        });
      } else if (getLastCharacter(1) == ' ' && getLastCharacter(2) == ')') {
        setState(() {
          expression = expression.substring(0, expression.length - 2);
          brackets++;
        });
      } else if (getLastCharacter(1) == ' ' && getLastCharacter(2) != ')') {
        getLastCharacter(2) != '%'
            ? setState(() {
                expression = expression.substring(0, expression.length - 3);
              })
            : setState(() {
                expression = expression.substring(0, expression.length - 2);
              });
      } else if (getLastCharacter(1) == '.') {
        setState(() {
          expression = expression.substring(0, expression.length - 1);
          isDot = false;
        });
      } else if (getLastCharacter(1) == '(') {
        setState(() {
          expression = expression.substring(0, expression.length - 1);
          brackets--;
        });
      } else {
        setState(() {
          expression = expression.substring(0, expression.length - 1);
        });
      }
    }
  }

  void calculate(String symbol) {
    if (isResult) {
      setState(() {
        hintExpression = hintExpression.substring(0, hintExpression.length - 2);
        expression = '';
        isNext = true;
        isResult = false;
      });
    }
    switch (symbol) {
      case '()':
        if (isDigit(1) ||
            isOperation(2) ||
            (expression.isEmpty ||
                getLastCharacter(1) == '(' ||
                getLastCharacter(1) == ')' ||
                getLastCharacter(2) != '%')) {
          if (isOperation(2) ||
              getLastCharacter(1) != ')' &&
                  ((brackets == 0 && getLastCharacter(1) == '') ||
                      (brackets > 0 && getLastCharacter(1) == '('))) {
            setState(() {
              expression = expression + '(';
              brackets++;
            });
          } else if ((getLastCharacter(2) == ')' || isDigit(1)) &&
              brackets > 0) {
            if (getLastCharacter(2) == ')') {
              setState(() {
                expression = expression.substring(0, expression.length - 1);
              });
            }
            setState(() {
              expression = expression + ') ';
              brackets--;
            });
          }
        }
        break;
      case '%':
        if (isDigit(1) &&
            getLastCharacter(1) != '' &&
            getLastCharacter(1) != ' ') {
          setState(() {
            expression = expression + '% ';
            isDot = false;
          });
        }
        break;
      case '÷':
        if (getLastCharacter(2) == ')' ||
            (isDigit(1) &&
                    getLastCharacter(1) != '' &&
                    getLastCharacter(1) != ' ' ||
                getLastCharacter(2) == '%')) {
          setState(() {
            getLastCharacter(2) != '%' ||
                    getLastCharacter(2) != ')' ||
                    getLastCharacter(1) != ')'
                ? expression = expression + ' / '
                : expression = expression + '/ ';
            isDot = false;
          });
        }
        break;
      case '×':
        if (getLastCharacter(2) == ')' ||
            (isDigit(1) &&
                    getLastCharacter(1) != '' &&
                    getLastCharacter(1) != ' ' ||
                getLastCharacter(2) == '%')) {
          setState(() {
            getLastCharacter(2) != '%' ||
                    getLastCharacter(2) != ')' ||
                    getLastCharacter(1) != ')'
                ? expression = expression + ' * '
                : expression = expression + '* ';
            isDot = false;
          });
        }
        break;
      case '+':
        if (getLastCharacter(2) == ')' ||
            (isDigit(1) &&
                    getLastCharacter(1) != '' &&
                    getLastCharacter(1) != ' ' ||
                getLastCharacter(2) == '%')) {
          setState(() {
            getLastCharacter(2) != '%' ||
                    getLastCharacter(2) != ')' ||
                    getLastCharacter(1) != ')'
                ? expression = expression + ' + '
                : expression = expression + '+ ';
            isDot = false;
          });
        }
        break;
      case '-':
        if (getLastCharacter(2) == ')' ||
            (isDigit(1) &&
                    getLastCharacter(1) != '' &&
                    getLastCharacter(1) != ' ' ||
                getLastCharacter(2) == '%')) {
          setState(() {
            getLastCharacter(2) != '%' ||
                    getLastCharacter(2) != ')' ||
                    getLastCharacter(1) != ')'
                ? expression = expression + ' - '
                : expression = expression + '- ';
            isDot = false;
          });
        }
        break;
      case ',':
        if (isDigit(1) && isDot == false) {
          setState(() {
            expression = expression + '.';
            isDot = true;
          });
        }
        break;
      case '=':
        expression.interpret();
        setState(() {
          hintExpression = expression + ' =';
          expression = expression.interpret().toString();
          expression = expression.substring(0, expression.length - 2);
          isResult = true;
          isNext = false;
          expressionFontSize = 70;
        });
        break;
      default:
        if (getLastCharacter(1) == '(' ||
            (isDigit(1) ||
                    getLastCharacter(1) == '.' ||
                    getLastCharacter(1) == '' ||
                    getLastCharacter(1) == ' ') &&
                (getLastCharacter(2) != '%')) {
          setState(() {
            expression = expression + symbol;
          });
        }
        break;
    }

    if (expression.length > 30) {
      setState(() {
        expressionFontSize = 36;
      });
    } else if (expression.length <= 30 && expression.length >= 20) {
      setState(() {
        expressionFontSize = 46;
      });
    } else if (expression.length >= 12 && expression.length < 19) {
      setState(() {
        expressionFontSize = 56;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          final snackBar = SnackBar(
                            content: const Text('FluSett'),
                            action: SnackBarAction(
                              label: 'Git',
                              onPressed: _openGit,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: Icon(
                          Icons.person_outline,
                          color: Theme.of(context).secondaryHeaderColor,
                        )),
                    Text(
                      'CALCULATOR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    Consumer(
                      builder: (context, ThemeNotifier themeNotifier, child) =>
                          IconButton(
                        onPressed: () {
                          themeNotifier.toggleTheme();
                        },
                        icon: Icon(
                          themeNotifier.isDarkTheme
                              ? Icons.bedtime
                              : Icons.bedtime_outlined,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        hintExpression,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          decoration: isNext
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        expression,
                        style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: expressionFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                brackets = 0;
                                isDot = false;
                                expression = '';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  'AC',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('()'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '( )',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('%'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '%',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('÷'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '÷',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('7'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '7',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('8'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '8',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('9'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '9',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('×'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '×',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('4'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '4',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('5'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '5',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('6'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '6',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('+'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('1'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('2'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('3'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('-'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('0'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  '0',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate(','),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  ',',
                                  style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: deleteLatest,
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                  child: Icon(
                                Icons.backspace_outlined,
                                color: Theme.of(context).hintColor,
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => calculate('='),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).dividerColor,
                                  shape: BoxShape.circle,
                                ),
                                width: 75,
                                height: 75,
                                child: Center(
                                  child: Text(
                                    '=',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).bottomAppBarColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
