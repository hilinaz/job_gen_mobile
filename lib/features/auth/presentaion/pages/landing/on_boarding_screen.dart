import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentStep = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Your AI-Powered\nAssistant",
      "description":
          "JobGen cuts through the noise. We combine AI-driven CV optimization with intelligent job matching to connect you directly with remote tech roles that are a perfect fit for your unique profile.",
    },
    {
      "title": "Reclaim Your Time",
      "description":
          "No more spending hours scrolling through irrelevant job posts. Get a shortlist of high-quality, matched opportunities delivered to you in seconds.",
    },
    {
      "title": "See Your Next Step Clearly",
      "description":
          "Understand exactly what skills you need to develop. Our match scores and feedback highlight skill gaps, giving you a clear roadmap for your professional development.",
    },
    {
      "title": "Apply with Certainty",
      "description":
          "Stop second-guessing your resume. Get the confidence that comes from knowing your CV is optimized to pass automated screens and impress human recruiters.",
    },
  ];

  void _nextStep() {
    setState(() {
      if (_currentStep < _onboardingData.length - 1) {
        _currentStep++;
      } else {
        Navigator.pushNamed(context,'/sign_up');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = _currentStep == _onboardingData.length - 1;
    final bool useWhiteBackground = _currentStep % 2 == 0;

    return Scaffold(
      body: Container(
        decoration: useWhiteBackground
            ? const BoxDecoration(color: Colors.white)
            : const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF86D7BF), Color(0xFF45A29E)],
                ),
              ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                // Title
                Text(
                  _onboardingData[_currentStep]["title"]!,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: useWhiteBackground
                        ? const Color(0xFF45A29E)
                        : Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                // Description
                Text(
                  _onboardingData[_currentStep]["description"]!,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: useWhiteBackground
                        ? const Color(0xFF45A29E)
                        : Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 48),
                // Button
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: useWhiteBackground
                          ? const Color(0xFF45A29E)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLastStep ? 'Start Now' : 'Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: useWhiteBackground
                                ? Colors.white
                                : const Color(0xFF45A29E),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: useWhiteBackground
                              ? Colors.white
                              : const Color(0xFF45A29E),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
