import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Number Trivia")), body: SingleChildScrollView(child: buildBody()));
  }

  BlocProvider<NumberTriviaBloc> buildBody() {
    return BlocProvider(
        create: (context) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return const MessageDisplay(
                            message: "Start Searching!");
                      } else if (state is Loading) {
                        return const LoadingWidget();
                      } else if (state is Loaded) {
                        return TriviaDisplay(numberTrivia: state.trivia);
                      } else if (state is Error) {
                        return MessageDisplay(message: state.message);
                      }else{
                      return const MessageDisplay(
                            message: "Start Searching!"); 
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TriviaControls()
                ],
              )),
        ));
  }
}

