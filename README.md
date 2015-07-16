This project was create to make easy the creation of new .h and .cpp files in
in c++.
These files will be created for a OOP.
Let's suppouse that the new class we need is "Dog", then executing:

	ncppc -c Dog

will create, in the same folder we're calling the application, two files. The
header file, dog.h:
	
	#ifndef DOG_H
	#define DOG_H

	class Dog {

	};

	#endif

and the source file, dog.cpp:

	#include "SHEET.h"

That's all.
