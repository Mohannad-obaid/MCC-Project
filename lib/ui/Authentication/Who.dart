import 'package:flutter/material.dart';

class Who extends StatefulWidget {
  const Who({super.key});

  @override
  State<Who> createState() => _WhoState();
}

class _WhoState extends State<Who> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
           Text(
            "الرجاء اختيار نوع الحساب",
            style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w300,
                fontSize: 25),
          ),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/signup',arguments: "patient");
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "images/patint.jpg",
                    bundle: null,
                    width: 90,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "مريض",
                      style: TextStyle(
                          color: Colors.green.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("التصفح كزائر"),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/signup',arguments: "doctor");
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "images/doctor.jpg",
                    width: 90,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "طبيب",
                      style: TextStyle(
                          color: Colors.green.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("اضافة المنشورات والمقالات"),
                  ],
                )
              ],
            ),
          ),
           SizedBox(
            height: MediaQuery.of(context).size.height * 0.28,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "لديك حساب؟",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 15),
                  ))
            ],
          ),
        ],
      ),
    ));
  }
}
