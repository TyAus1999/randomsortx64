#include <iostream>
#include <thread>
#include <cstdlib>
#include <stdio.h>
#include <chrono>
#include <assert.h>
#include <vector>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xos.h>
#include "drawingLib.h"
using namespace std;
struct card;
extern "C" {//the first six parameters go into rdi, rsi, rdx, rcx, r8, and r9.
    uint64_t actualGen(int n);
    uint64_t fib(uint64_t n);
    uint64_t prob4(uint64_t* array,uint64_t length);
    void bubbleSort(uint64_t*array,uint64_t length);
    uint64_t* fillArrayWithRandom64(uint64_t length);
    uint64_t genRandom64(void);
    void sortHighestNumber(uint64_t*array, uint64_t length);
    void whileLoopTest(uint64_t amount);
    uint64_t primeNumberFinder(uint64_t in);
    void setCursor(unsigned long x, unsigned long y);
    void writeChar(unsigned long c);

    void pokerHand(card*c);

    int64_t echoTest(void);

    void printfGraphicsTest(void);

    double floatingPointTest(long in);

    double asmPI(unsigned long max);

    bool evenOdd(unsigned long in);

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
void sortComparison(void){
    uint64_t length=0xffff;
    int64_t bsSortTime=bubbleSort(length);
    int64_t sSortTime=singleSort(length);
    cout<<"Single Sort took "<<sSortTime<<"ms"<<endl;
    cout<<"Bubble Sort took " << bsSortTime <<"ms"<<endl;
}
void keyThread(){
    while(1){

    }
}
struct Box{
    int x,y,colour;
    bool xDir,yDir;
    int speed;
};
void gt(){
        drawingLib d(750,500,keyThread);
    vector<Box> boxes;
    for(int i=0;i<50;i++){
        uint64_t r=genRandom64();
        r%=1000;
        Box temp;
        r=genRandom64();
        r%=5;
        while(r>5 || r<1){
            r=genRandom64();
            r%=6;
        }
        temp.colour=r;
        r=genRandom64();
        r%=750;
        temp.y=r;
        r=genRandom64();
        r%=500;
        temp.x=r;
        r=genRandom64();
        r%=100;
        if(r>50){
            temp.xDir=false;
            temp.yDir=true;
            temp.speed=2;
        }
        else{
            temp.xDir=true;
            temp.yDir=false;
            temp.speed=1;
        }
        boxes.push_back(temp);
        cout<<temp.x<<endl<<temp.y<<endl<<temp.colour<<endl<<temp.xDir<<endl<<temp.yDir<<endl;
    }
    while(true){
        for(unsigned int i=0;i<boxes.size();i++){
            d.fillRect(boxes[i].x,boxes[i].y,50,50,0);
            if(boxes[i].xDir){
                boxes[i].x+=boxes[i].speed;
                if(boxes[i].x>700)boxes[i].xDir=false;
            }
            else{
                boxes[i].x-=boxes[i].speed;
                if(boxes[i].x<1)boxes[i].xDir=true;
            }

            if(boxes[i].yDir){
                boxes[i].y+=boxes[i].speed;
                if(boxes[i].y>450)boxes[i].yDir=false;
            }
            else{
                boxes[i].y-=boxes[i].speed;
                if(boxes[i].y<1)boxes[i].yDir=true;
            }
            d.fillRect(boxes[i].x,boxes[i].y,50,50,boxes[i].colour);
        }
        d.sleepM(10);
    }

    //thread keys(keyThread);
    char c;
    cin>>c;
    //keys.join();
}
void sleepM(int n){
    std::this_thread::sleep_for(std::chrono::milliseconds(n));
}
void stuff(){
    double t=8.8;
    double h=10.111;
    t+=0.1;
    t=5.5;
    double g=t*h;
    //unsigned long * q=new unsigned long (0xfffffffffffffffe);
    unsigned long * p=(unsigned long *) malloc (sizeof(unsigned long)*2);
    cout<<p<<endl;
    for(unsigned int i=0;i<0xffffffff;i++){
        try{
        if(*(p+i)!=0)
            cout<<i<<":"<<*(p+i)<<endl;
        }
        catch(exception & e){
            cout<<"At " << i<<endl;
        }
        //sleepM(50);
    }
    cout<<g<<endl;
}
struct card{
    char cardType;
    char cardSuit;
};
void calcPi(){
    register double pi=0;
    register unsigned long i;
    register unsigned long max=0xffffffffffffffff;
    register bool flip=false;
    for(i=1;i<max;i+=2){
        if(flip){
            pi+=(double)4/(double)i;
            flip=false;
        }
        else{
            pi-=(double)4/(double)i;
            flip=true;
        }
        if(i%0xffffffff==0){
            printf("%.64g\n",abs(pi));
            printf("%.2g\n",(double)((double)i/(double)max));
        }
    }
}
void calcPiThreadSlave(bool*in,double*pi,unsigned long start,unsigned long amount){
    bool flip=false;
    for(unsigned long i=start;i<start+amount;i+=2){
        if(flip){
            flip=false;
            *pi+=(double)1/(double)i;
        }
        else{
            flip=true;
            *pi-=(double)1/(double)i;
        }
    }
    *in=true;
}
double calcPiThreads(unsigned long keepTrackAmount,unsigned long maxStartedThreads){
    double pi=1;
    //unsigned long max=0xffffffffffffffff;
    unsigned long keepTrack=3;
    unsigned long startedThreads=0;
    unsigned long last=0;
    int maxThreads=5;
    thread t[maxThreads];
    bool *threadBool=(bool*)malloc(sizeof(bool)*maxThreads);
    for(int i=0;i<maxThreads;i++)
        *(threadBool+i)=true;
    while(1){
        for(int i=0;i<maxThreads;i++){
            if(*(threadBool+i)){
                *(threadBool+i)=false;
                if(t[i].joinable())t[i].join();
                t[i]=thread(calcPiThreadSlave,(threadBool+i),&pi,keepTrack,keepTrackAmount);
                startedThreads++;
                keepTrack+=keepTrackAmount;
            }
            else{
                t[i].join();
            }
        }

        double percentDone=(double)((double)startedThreads/(double)maxStartedThreads);
        percentDone*=100;
        unsigned long noDec=(unsigned long)percentDone;
        if(last!=noDec){
            cout<<noDec<<"%"<<endl;
            last=noDec;
            double temp=pi*4;
            printf("%s%.64g\n","PI: ",temp);
        }

        if(startedThreads>maxStartedThreads)break;
        
        
        //break;
    }
    //printf("%s%.64g\n","PI: ",abs(pi));
    for(int i=0;i<maxThreads;i++)
        if(t[i].joinable())t[i].join();
    free(threadBool);
    return abs(pi);
}
double testF(double in){
    double out=in;
    out*=2.2;
    return out;
}
int main(){
    //double r=asmPI(0x5);
    //printf("%.64g\n",abs(r));
    double pi=calcPiThreads(150,0xfffff);
    //while(pi<3)
        //pi=calcPiThreads(7000,7000);
        double temp=pi*4;
    printf("%s%.64g\n","PI: ",temp);

    //printfGraphicsTest();
    
    /*
    int64_t start=getTimeNow();
    whileLoopTest((uint64_t)1000000000000);
    int64_t end=getTimeNow();

    cout<<"Time taken: " << (double)(end-start)/1000 << "s"<<endl;
    

    for(int i=0;i<100;i++){
        cout<<i<<":"<<primeNumberTest(i)<<endl;
    }
    */
    /*
    int64_t start=getTimeNow();
    for(uint64_t i=0xFFFFFFFFFFFFFFFF;i>0;i--){
        if(primeNumberFinder(i)==1)
            cout<<i<<":yes"<<endl;
    }
    cout<<"Time taken: " << getTimeNow()-start<<endl;

    cout<<"Start"<<endl;
    unsigned long amount=0xfffffff;
    cout<<"S"<<endl;
    unsigned long* numberPointer=(unsigned long*)malloc(sizeof(unsigned long)*amount);
    cout<<"B"<<endl;
    try{
        cout<<"C"<<endl;
        for(unsigned long i=0;i<amount;i++){
            cout<<i<<endl;
            *(numberPointer+i)=genRandom64();
        }
    }
    catch(std::exception &e){
        std::cerr << "Exception caught : " << e.what() << std::endl;
    }
    cout<<"Finished filling array"<<endl;
    sleepM(10000);
    free(numberPointer);
    */
    return(0);
}