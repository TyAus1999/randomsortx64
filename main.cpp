#include <iostream>
#include <thread>
#include <cstdlib>
#include <chrono>
using namespace std;
extern "C" {//the first six parameters go into rdi, rsi, rdx, rcx, r8, and r9.
    uint64_t actualGen(int n);
    uint64_t fib(uint64_t n);
    uint64_t prob4(uint64_t* array,uint64_t length);
    uint64_t* bubbleSort(uint64_t*array,uint64_t length);
    uint64_t* fillArrayWithRandom64(uint64_t length);
}
int64_t getTimeNow(){
    return chrono::duration_cast<chrono::milliseconds>(chrono::steady_clock::now().time_since_epoch()).count();
}
void randomSort(void){
    uint64_t passes=0;
    while(passes<20){
        int64_t start = getTimeNow();
        uint64_t amountOfTimes=actualGen(passes);
        int64_t end = getTimeNow();
        cout<<"It took " << amountOfTimes << " times to random sort on #" << passes<<endl;
        cout<<"It took " << (end-start)<<"ms"<<endl;
        passes++;
    }
}
int main(){
    uint64_t length=30;
    uint64_t* arr=fillArrayWithRandom64(length);
    for(uint64_t i=0;i<length;i++){
        cout<<"Array pos " << i << "="<<*(arr+i)<<endl;
    }
    free(arr);
    return 0;
}