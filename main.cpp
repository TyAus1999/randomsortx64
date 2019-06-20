#include <iostream>
#include <thread>
#include <cstdlib>
#include <chrono>
using namespace std;
extern "C" {//the first six parameters go into rdi, rsi, rdx, rcx, r8, and r9.
    uint64_t actualGen(int n);
    uint64_t fib(uint64_t n);
    uint64_t prob4(uint64_t* array,uint64_t length);
    void bubbleSort(uint64_t*array,uint64_t length);
    uint64_t* fillArrayWithRandom64(uint64_t length);
    uint64_t genRandom64(void);
    void sortHighestNumber(uint64_t*array, uint64_t length);
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
void blah(void){
    uint64_t length=131072*1024;
    /*uint64_t* arr=(uint64_t*)malloc(8*length);
    for(uint64_t i=0;i<length;i++){
        *(arr+i)=genRandom64();
        cout<<"Value at "<<i<<":"<<*(arr+i)<<endl;
    }
    free(arr);*/
    uint64_t* arr=fillArrayWithRandom64(length);
    cout<<"Done"<<endl;
    /*for(uint64_t i=0;i<length;i++){
        cout<<"Array pos " << i << "="<<*(arr+i)<<endl;
    }*/
    char c;
    cin>>c;
    free(arr);
}
int64_t bubbleSort(uint64_t l){
    int64_t mallocAndFillStart=getTimeNow();
    uint64_t* arr=fillArrayWithRandom64(l);
    int64_t mallocAndFillTotal=getTimeNow()-mallocAndFillStart;
    int64_t bsStart=getTimeNow();
    bubbleSort(arr,l);
    int64_t bsTotal=getTimeNow()-bsStart;
    int64_t displayTimeStart=getTimeNow();
    for(uint64_t i=0;i<l;i++){
        cout<<"Value at " << i << "\t="<<*(arr+i)<<endl;
    }
    int64_t displayTimeTotal=getTimeNow()-displayTimeStart;
    int64_t deno=(mallocAndFillTotal+bsTotal+displayTimeTotal);
    cout<<"Malloc and fill took "<<mallocAndFillTotal<<"ms " << ((float)mallocAndFillTotal/(float)deno)*100<<"%" <<endl;
    cout<<"Bubble Sort took " <<bsTotal<<"ms "<<((float)bsTotal/(float)deno)*100<<"%"<<endl;
    cout<<"Display time took " <<displayTimeTotal<<"ms "<<((float)displayTimeTotal/(float)deno)*100<<"%"<<endl;
    cout<<"For " << l << " amount of items"<<endl;
    cout<<"Total time " <<(mallocAndFillTotal+bsTotal+displayTimeTotal)<<"ms"<<endl;
    char c;
    cin>>c;
    free(arr);
    return deno;
}
int64_t singleSort(uint64_t length){
    int64_t mallocAndFillStart=getTimeNow();
    uint64_t* arr=fillArrayWithRandom64(length);
    int64_t mallocAndFillTotal=getTimeNow()-mallocAndFillStart;
    int64_t sortHNStart=getTimeNow();
    sortHighestNumber(arr,length);
    int64_t sortHNTotal=getTimeNow()-sortHNStart;
    int64_t displayTimeStart=getTimeNow();
    for(uint64_t i=0;i<length;i++){
        cout<<"Value at " << i << "\t="<<*(arr+i)<<endl;
    }
    int64_t displayTimeTotal=getTimeNow()-displayTimeStart;
    int64_t deno=(mallocAndFillTotal+sortHNTotal+displayTimeTotal);
    cout<<"Malloc and fill took "<<mallocAndFillTotal<<"ms " << ((float)mallocAndFillTotal/(float)deno)*100<<"%" <<endl;
    cout<<"Single Sort took " <<sortHNTotal<<"ms "<<((float)sortHNTotal/(float)deno)*100<<"%"<<endl;
    cout<<"Display time took " <<displayTimeTotal<<"ms "<<((float)displayTimeTotal/(float)deno)*100<<"%"<<endl;
    cout<<"For " << length << " amount of items"<<endl;
    cout<<"Total time " <<(mallocAndFillTotal+sortHNTotal+displayTimeTotal)<<"ms"<<endl;
    char c;
    cin>>c;
    free(arr);
    return deno;
}
int main(){
    uint64_t length=0xffffff;
    int64_t bsSortTime=8;//bubbleSort(length);
    int64_t sSortTime=singleSort(length);
    cout<<"Single Sort took "<<sSortTime<<"ms"<<endl;
    cout<<"Bubble Sort took " << bsSortTime <<"ms"<<endl;

    return 0;
}