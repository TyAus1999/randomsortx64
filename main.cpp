#include <iostream>
#include <thread>
#include <cstdlib>
#include <chrono>
using namespace std;
extern "C" {//the first six parameters go into rdi, rsi, rdx, rcx, r8, and r9.
    uint64_t actualGen(int n);
}
int64_t getTimeNow(){
    return chrono::duration_cast<chrono::milliseconds>(chrono::steady_clock::now().time_since_epoch()).count();
}
int main()
{
    uint64_t passes=0;
    while(passes<20){
        int64_t start = getTimeNow();
        uint64_t amountOfTimes=actualGen(passes);
        int64_t end = getTimeNow();
        cout<<"It took " << amountOfTimes << " times to random sort on #" << passes<<endl;
        cout<<"It took " << (end-start)<<"ms"<<endl;
        passes++;
    }
    return 0;
}