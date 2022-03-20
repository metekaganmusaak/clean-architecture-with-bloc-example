import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart' as di;
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clean Architecture & BLoC"),
      ),
      body: SingleChildScrollView(
        child: buildBody(),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody() {
    return BlocProvider(
      create: (context) => di.sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

              // top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (BuildContext context, NumberTriviaState state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start Searching!',
                    );
                  } else if (state is Loaded) {
                    return TriviaDisplay(trivia: state.trivia);
                  } else if (state is Loading) {
                    return const LoadingDisplay();
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.errorMessage,
                    );
                  } else {
                    return const Text("Ah baby");
                  }
                },
              ),
              const Divider(),
              const TriviaButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class TriviaButtons extends StatefulWidget {
  const TriviaButtons({Key? key}) : super(key: key);

  @override
  State<TriviaButtons> createState() => _TriviaButtonsState();
}

class _TriviaButtonsState extends State<TriviaButtons> {
  late final TextEditingController controller;
  late String inputString;

  @override
  void initState() {
    inputString = "";
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    inputString = "";
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) => dispatchConcrete(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text("Search"),
                onPressed: dispatchConcrete,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                child: const Text("Get Random Trivia"),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
