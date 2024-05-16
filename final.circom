pragma circom 2.1.6;


include "circomlib/circuits/mux3.circom"; 
include "circomlib/circuits/mux2.circom"; 
include "circomlib/circuits/mux1.circom"; 
include "circomlib/circuits/comparators.circom"; 
// include "Multiplication.circom";
// include "AddSub.circom";


template AddSub () {
  signal input in1;
  signal input in2;

 // Decalring intermediate signals
  signal int_sign1;
  signal int_sign2;
  signal  int_mag1;
  signal int_mag2;
  signal  result ;
  signal  finalResult;
  signal  sign;
  signal output out;


  // asserting input signal values to be less than sqaure rooot of prime field
    //  assert(in1 < 147946756881789319005730692170996259609 );
    //  assert(in2 < 147946756881789319005730692170996259609 );

// extracting magnitude and sign bit for in1
  int_sign1 <-- in1%10;
  int_mag1 <-- in1\10;
  in1 === int_mag1*10 + int_sign1;



// extracting magnitude and sign bit for in2

  int_sign2 <-- in2%10;
  int_mag2 <-- in2\10;
  in2 === int_mag2*10 + int_sign2;


//performing add/sub operations

 component mux3 = Mux2();

 mux3.c[0] <== int_mag1 + int_mag2;
 mux3.c[1] <== int_mag1 - int_mag2;
 mux3.c[2] <== int_mag1 - int_mag2;
 mux3.c[3] <== int_mag1 + int_mag2;
 mux3.s[0] <== int_sign1;
 mux3.s[1] <== int_sign2;
 result <== mux3.out;

 signal checker;

component check = LessThan(252);

 check.in[0] <== 0;
 check.in[1] <== result;

checker <== check.out;

component mux4 = Mux1();

mux4.c[0] <== (int_mag2 - int_mag1);
mux4.c[1] <==  result;
mux4.s <== checker;

finalResult <== mux4.out;

// assigning sign bit 

signal checker1;

component check2 =  LessThan(252);

check2.in[0] <==  int_mag1;
check2.in[1] <== int_mag2;


checker1 <==  check2.out;


 component mux5 = Mux1();

 mux5.c[0] <== int_sign1;
 mux5.c[1] <== int_sign2;
 mux5.s <== checker1;

 sign <== mux5.out;

 out <== (finalResult*10) + sign;



}

template Sub () {
  signal input in1;
  signal input in2;

 // Decalring intermediate signals
  signal output int_sign1;
  signal output int_sign2;
  signal  output int_mag1;
  signal output int_mag2;
  signal  output result ;
  signal  output finalResult;
  signal  output sign;
  signal output out;


  // asserting input signal values to be less than sqaure rooot of prime field
    //  assert(in1 < 147946756881789319005730692170996259609 );
    //  assert(in2 < 147946756881789319005730692170996259609 );

// extracting magnitude and sign bit for in1
  int_sign1 <-- in1%10;
  int_mag1 <-- in1\10;
  in1 === int_mag1*10 + int_sign1;



// extracting magnitude and sign bit for in2

  int_sign2 <-- in2%10;
  int_mag2 <-- in2\10;
  in2 === int_mag2*10 + int_sign2;

// assigning sign bit 

signal output  checker1;

component check2 =  LessThan(252);

check2.in[0] <==  int_mag1;
check2.in[1] <== int_mag2;


checker1 <==  check2.out;

component mux3 = Mux3();

mux3.c[0] <== int_mag1 - int_mag2;
mux3.c[1] <== int_mag2 - int_mag1;
mux3.c[2] <== int_mag1 + int_mag2;
mux3.c[3] <== int_mag1 + int_mag2;
mux3.c[4] <== int_mag1 + int_mag2;
mux3.c[5] <== int_mag1 + int_mag2;
mux3.c[6] <== int_mag1 - int_mag2;
mux3.c[7] <== int_mag2 - int_mag1;

mux3.s[0] <== checker1;
mux3.s[1] <== int_sign2;
mux3.s[2] <== int_sign1;

finalResult <== mux3.out;

component mux5 = Mux3();

 mux5.c[0] <== 0;
 mux5.c[1] <== 1;
 mux5.c[2] <== 0;
 mux5.c[3] <== 0;
 mux5.c[4] <== 1; 
 mux5.c[5] <== 0; 
 mux5.c[6] <== 1; 
 mux5.c[7] <== 0; 
 mux5.s[0] <== checker1;
 mux5.s[1] <== int_sign2;
 mux5.s[2] <== int_sign1;

 sign <== mux5.out;

 out <== (finalResult*10) + sign;

}

template Mul() {
    signal input a;
    signal input b;
    signal output out;

    var scale = 1000000000000000000;

    // assert(a < 147946756881789319005730692170996259609 );
    // assert(b < 147946756881789319005730692170996259609 );

    signal a_sign <-- a % 10; //no constraint
    signal a_value <-- a \ 10; //no constraint
    a === (a_value*10) + a_sign; // constrain

    signal b_sign <-- b % 10;
    signal b_value <-- b \ 10;
    b === (b_value*10) + b_sign;

    signal out_value_scaled <== a_value*b_value;
    signal out_value <-- out_value_scaled \ scale;
    //out_value_scaled === out_value*scale;

        // assigning sign bit
    component mux = Mux2(); 
    mux.c[0] <== 0;
    mux.c[1] <== 1;
    mux.c[2] <== 1;
    mux.c[3] <== 0;

    mux.s[0] <== a_sign;
    mux.s[1] <== b_sign;
    
    signal out_sign <== mux.out;

    out <== (out_value*10) + out_sign;
}




template taylorSeries () {
    signal input x;
    //declaring constants for the series 
    signal one <== 2500000000000000000;
    signal two <== 208333333333333331;
    signal three <== 20833333333333330;
    signal four <== 5000000000000000000;
    signal output out ;

//using multiplication library to multiply the terms 
component mul = Mul();

mul.a <== one;
mul.b <== x;
signal first_term <== mul.out;

component mul1 = Mul();

mul1.a <== x;
mul1.b <== x;
signal second_term_one <== mul1.out;

component mul2 = Mul();

mul2.a <== x;
mul2.b <== second_term_one;
signal second_term_second <== mul2.out;


component mul3 = Mul();

mul3.a <== second_term_second ;
mul3.b <== two;

signal second_term_final <== mul3.out;

component mul4 = Mul();

mul4.a <== second_term_second;
mul4.b <== second_term_one;
signal third_term_first <== mul4.out;

component mul5 = Mul();

mul5.a <== third_term_first;
mul5.b <== three;

signal third_term_final <== mul5.out;


// log(first_term);
// log(second_term_final);
// log(third_term_final);

//signal series <== 5000000000000000000 + first_term + second_term_final + third_term_final ;

//using AddSub library to add the terms 
component add = AddSub();

add.in1 <== four;
add.in2 <== first_term;
signal int1 <== add.out;

component add1  = AddSub();
add1.in1 <== int1;
add1.in2 <== second_term_final;
signal int2 <== add1.out;

component add2  = AddSub();
add2.in1 <== int2;
add2.in2 <== third_term_final;
signal series <== add2.out;
// log(int1);
// log(int2);
// log(series);

out <== series ;

}

// component main = taylorSeries();



//0.51372296
//1st trial 
// 91942840000000000
// 5022985548076890730

   

// 50000000000000000000



template logisticRegression2(m,n,number) {
  signal input a[m][n];
  signal input w[n];
  signal input ans[m];
  signal ins[m+1][n+1][number+1];
  signal  insa[m+1][n+1][number+1];
  signal insta[m][number];
  signal output x[m][number+1];
  signal x_sign[m][number+1];
  signal x_value[m][number+1];
  signal   taylorResult[m][number+1];
  signal taylorRemainder[m][number+1];
  signal  result[m][number+1];
  signal  resultL[m][number+1];
  signal  resultG[m][number+1];
  signal efficiencyDivisor;
   signal  efficiencySignal;
   signal output  efficiencyCheck ;
   signal efficiency;
   signal taylorSeriesChecker[m];
   signal finalResult[m];
   signal output error[m][number];
   signal output errorSum[m+1][number+1];
   signal output taylorAns[m][number];
   signal output errorMul[m+1][n+1][number];
   signal output errorMulA[m+1][n+1][number];
   signal output finalError[n][number];
   signal output dw[n][number];
   signal output ddw[n][number];
   signal output weights[n][number+1];
   signal  output bias[number+1];
   signal output db[number+1];
   signal ddb[number +1];
   signal dddb[number+1];


 // declaring components for mul and add
component mult[m+1][n+1][number+1] ;
component adds[m+1][n+1][number+1] ;
component taylor[m+1][number+1];
component check[m+1][number+1];
component checker;
component lessChecker[m][number+1];
component moreChecker[m][number+1];
component runCheck;
component seriesAssigner[m];
component signChecker[m];
 component multiplying[m][n][number+1];
    component added[m][n][number+1];
        component multiplied[n][number+1];
     component substract[n][number+2];
    component adding[m][number+1];
    component multi[n][number+1];
    component addi[m][number];
    component addit[m][number];
    component multis[number];
    component multisa[number];
    component subz[number];

    
       var count = 0;

       weights[0][0] <==  0;
       weights[1][0] <== 0;
       bias[0] <== 0;

for(var num =0 ; num <number;num++){
    
for(var j =0; j<m; j++){
    ins[j][0][num] <== 0;
    insa[j][0][num] <== 0;
    
    // for(var i=0;i<28;i++){
    //     ins[j][i+1] <== ins[j][i] + a[j][i]*w[i];
    // }

// performing MAC operations 

    for(var i=0;i<n;i++){
       // weights[i][num] <== w[i];
        mult[j][i][num] = Mul();
        adds[j][i][num] = AddSub();
        

        mult[j][i][num].a <== a[j][i] ;
        mult[j][i][num].b <== weights[i][num];
        ins[j][i+1][num] <== mult[j][i][num].out;

        adds[j][i][num].in1 <== insa[j][i][num];
         adds[j][i][num].in2 <== ins[j][i+1][num];
         insa[j][i+1][num] <== adds[j][i][num].out;
        
    }

    addi[j][num] = AddSub();

    addi[j][num].in1 <== bias[num];
    addi[j][num].in2 <== insa[j][n][num];
    insta[j][num] <== addi[j][num].out;    

    x[j][num] <==  insta[j][num];
    log(x[j][num]);

    x_sign[j][num] <-- x[j][num]%10;
    x_value[j][num] <-- x[j][num]\10;
    x[j][num] === x_value[j][num]*10 + x_sign[j][num];

    

    lessChecker[j][num] = LessThan(252);
    lessChecker[j][num].in[0] <== 2000000000000000000;
    lessChecker[j][num].in[1] <== x_value[j][num];
    resultL[j][num] <== lessChecker[j][num].out; 

    moreChecker[j][num] = LessThan(252);
    moreChecker[j][num].in[0] <== 3000000000000000000;
    moreChecker[j][num].in[1]  <== x_value[j][num];
    resultG[j][num] <== moreChecker[j][num].out;


    //feeding the output to taylor series 
    taylor[j][num] = taylorSeries();
    taylor[j][num].x <== x[j][num];
    taylorResult[j][num] <-- taylor[j][num].out \ 10;
    taylorRemainder[j][num] <-- taylor[j][num].out% 10;
    taylor[j][num].out === taylorResult[j][num]*10 + taylorRemainder[j][num];

    taylorAns[j][num] <== taylor[j][num].out;
    log(taylorAns[j][num]);
}


    // component multiplying

    for( var e =0; e < m ; e++){
        adding[e][num] = Sub();
        adding[e][num].in1 <== taylorAns[e][num];
        adding[e][num].in2 <== ans[e];
        error[e][num] <== adding[e][num].out; 
     }
    
    errorSum[0][num] <== 0;
     for(var t=0;t < m;t++){
        addit[t][num] = AddSub();
        addit[t][num].in1 <== error[t][num];
        addit[t][num].in2 <== errorSum[t][num];
        errorSum[t+1][num] <== addit[t][num].out;
     }
    
    ddb[num] <==  errorSum[m][num]; 

     multis[num] = Mul();
    multis[num].a <== (1/m)*(10000000000000000000);
    multis[num].b <== 100000000000000000;
    dddb[num] <== multis[num].out;

     multisa[num] = Mul();
    multisa[num].a <== dddb[num];
    multisa[num].b <== ddb[num];
    db[num] <== multisa[num].out;

     subz[num] = Sub();
    subz[num].in1 <== bias[num];
    subz[num].in2 <== db[num];
    bias[num+1] <== subz[num].out;
   

     for (var g =0;g < n;g++){
       errorMulA[0][g][num] <== 0;
       for(var f = 0; f < m;f++){
        multiplying[f][g][num] = Mul();

        // 5000000000000000000
        multiplying[f][g][num].a <== a[f][g];
        multiplying[f][g][num].b <== error[f][num];
        errorMul[f][g][num] <== multiplying[f][g][num].out;

        added[f][g][num] = AddSub();

        added[f][g][num].in1 <== errorMul[f][g][num];
        added[f][g][num].in2 <== errorMulA[f][g][num];
        errorMulA[f+1][g][num] <== added[f][g][num].out;
       }
       finalError[g][num] <== errorMulA[m][g][num];
     }

    

     for(var s =0 ; s< n; s++){
       multiplied[s][num] = Mul();
       multi[s][num] = Mul();
       multiplied[s][num].a <== (1/m)*(10000000000000000000);
       multiplied[s][num].b <== 100000000000000000;
       ddw[s][num] <==  multiplied[s][num].out;
       

       multi[s][num].a <== ddw[s][num];
       multi[s][num].b <== finalError[s][num];
       dw[s][num] <== multi[s][num].out;

    //   dw[s][num] <== (1/m)*(1/100)*finalError[s][num];
      
      substract[s][num] = Sub();
      substract[s][num].in1 <== weights[s][num];
      substract[s][num].in2 <== dw[s][num];
      weights[s][num+1] <== substract[s][num].out;

     }

     
}
}

// 200000000000000000001
// 25000000000000000
// 25000000000000000
// 500000000000000001
component main = logisticRegression2(4,2,5);

/* INPUT = {
    "a": [[10000000000000000000,20000000000000000000],[20000000000000000000,30000000000000000000],[30000000000000000000,40000000000000000000],[40000000000000000000,50000000000000000000]],
    "w":[0,0],
    "ans": [0,0,10000000000000000000,10000000000000000000]
} */


// 137503645598769951839870
// 3709472656249999280

// 500000000000000000
// 500000000000000001
// 50000000000000000

// 500000000000000000

// 50000000000000000



       
//     //log(taylorResult[j]);

//     seriesAssigner[j] = Mux3();
//     seriesAssigner[j].c[0] <== taylorResult[j];
//     seriesAssigner[j].c[1] <== taylorResult[j];
//     seriesAssigner[j].c[2] <== taylorResult[j];
//     seriesAssigner[j].c[3] <== 0;
//     seriesAssigner[j].c[4] <== 1;
//     seriesAssigner[j].c[5] <== taylorResult[j];
//     seriesAssigner[j].c[6] <== 1;
//     seriesAssigner[j].c[7] <== 0;

//     seriesAssigner[j].s[0] <== x_sign[j];
//     seriesAssigner[j].s[1] <== resultL[j];
//     seriesAssigner[j].s[2] <== resultG[j];
//     // log(x_sign[j]);
//     // log(resultL[j]);
//     // log(resultG[j]);

//     finalResult[j]  <== seriesAssigner[j].out;

// // component to check series result is < or > 0.5 
//     check[j] = LessThan(252);
//     check[j].in[0] <== 500000000000000000;
//     check[j].in[1] <== finalResult[j];
//     result[j] <== check[j].out;    

// // comparing circuit results with ml results to confirm >90% efficiency
//     if(result[j] == ans[j]){
//         count ++;
//     }
 
//     //14731249999999997840
//     //500000000000000000
//     //9.0000000000000000000
//     //1.0000000000000000000
//     //5810580403017215662
//     //500000000000000000
// } 
//  log(count);

//   efficiency <-- (count/m);
//   //efficiency*m === count;
//    efficiencySignal <== efficiency*1000;


//     checker  = GreaterThan(252);

//  checker.in[0] <== efficiencySignal;
//  checker.in[1] <== 900;
//   efficiencyCheck <== checker.out;
//   log(efficiencySignal);
// log(efficiencyCheck);
//   // efficiencyCheck === 1;

// }





//3580413743742244339944


//5.2030717284542256281

 //0.005469564369535000
 //5469564369535000
 //5810580403017215662
 //5000000000000000000
 //0.005469564369525101

// 500000000000000000
// 5810580403017215662

