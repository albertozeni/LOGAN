#include<string>
#include<vector>
#include<iostream>
#include <fstream> 
#include <sstream> 
#include <iterator>
using namespace std;

int main(int argc, char const *argv[])
{
	string file = argv[1];
	std::fstream fs;
	std::vector<string> querys;
	std::vector<string> db;
	
	ifstream in(file);

	if(!in) {
		cout << "Cannot open input file.\n";
		return 1;
	}


	int counter = 0;
	string s;
	while(getline(in, s)){  // delim defaults to '\n'
		
		std::string token;
		std::vector<std::string> tokens;
		std::istringstream iss(s);
    	while(std::getline(iss, token, '\t'))   // but we can specify a different one
        	tokens.push_back(token);
        querys.push_back(">Q"+to_string(counter));
    	db.push_back(">DB"+to_string(counter));
    	counter++;
    	querys.push_back(tokens[0]);
    	db.push_back(tokens[2]);
	}
	
	std::ofstream output_file1("db.fa");
    std::ostream_iterator<std::string> output_iterator1(output_file1, "\n");
    std::copy(db.begin(), db.end(), output_iterator1);

    std::ofstream output_file2("query.fa");
    std::ostream_iterator<std::string> output_iterator2(output_file2, "\n");
    std::copy(querys.begin(), querys.end(), output_iterator2);

	return 0;
}
