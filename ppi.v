
module PPI (RESET,CS,RD,WR,sel,PA,PB,PC,PD);
input RESET,CS,RD,WR;
inout [7:0] PA,PB,PC,PD;
reg[7:0] a;
reg[7:0] b;
reg[7:0] c;
reg[7:0] d;
reg[7:0] cr;
input[1:0] sel;// variable contains A0,A0 ,use this variable to check for them 

assign PA=a;
assign PB=b;
assign PC=c;
assign PD=d;
always @(RESET,CS,RD,WR,sel,cr)
begin
 if(RESET)        //reset=high initialize all ports as inputs 
 begin
 a<= 8'bzzzzzzzz;
 b<= 8'bzzzzzzzz;
 c<= 8'bzzzzzzzz;
 end

 else
 begin
	if(!CS) //enable the 8255 chip
	begin
	  if(cr[7]==0) //BSR mode , port c is selected
	   begin
	   d[6]=0;
           d[5]=0;
           d[4]=0;
	   case(cr[3:0])
       4'b0000:c[0]<=0;
       4'b0001:c[0]<=1;
       4'b0010:c[1]<=0;
       4'b0011:c[1]<=1;
       4'b0100:c[2]<=0;
       4'b0101:c[2]<=1;
       4'b0110:c[3]<=0;
       4'b0111:c[3]<=1;
       4'b1000:c[4]<=0;
       4'b1001:c[4]<=1;
       4'b1010:c[5]<=0;
       4'b1011:c[5]<=1;
       4'b0110:c[6]<=0;
       4'b0111:c[6]<=1;
       4'b1110:c[7]<=0;
       4'b1111:c[7]<=1;
endcase
          end
	
          else if(cr[7]==1)// I/O mode
          begin
	         if(!RD && WR==1 &&(cr[0]==0 ||cr[1]==0 ||cr[3]==0 ||cr[4]==0) )//mode 0,input mode
	         begin
                   case(sel)
                   2'b00:	d=RD?8'bzzzzzzzz:a;
                    //port A to databus
                   2'b01: d=RD?8'bzzzzzzzz:b; //port b to databus
                   2'b10:d=RD?8'bzzzzzzzz:c;  //port c to databus		
                   endcase
                               end
                   else if (!WR) //mode 0,0utput mode
                   begin
                   case (sel)
                   2'b00:a<=WR?8'bzzzzzzzz:d;	//databus to port A
                   2'b01:b<=WR?8'bzzzzzzzz:d;	 //databus to port B
                   2'b10:c<=WR?8'bzzzzzzzz:d;	 //databus to port C
                   2'b11:cr<=WR?8'bzzzzzzzz:d;
                   endcase
            end                 
           end
          end
end
end
endmodule 








module ppi_tb();
reg RESET,CS,RD,WR;
wire[7:0] PA;   //assign PA = (wr &&~rd)? PAt : 
wire[7:0] PB;
wire[7:0] PC;
wire[7:0] PD;

reg[1:0] sel;

reg[7:0] A;   //assign PA = (wr &&~rd)? PAt : 
reg[7:0] B;
reg[7:0] C;
reg[7:0] D;



assign PA=() ? 8'bzzzzzzz: A;
assign PB=B;
assign PC=C;
assign PD=D;

initial
begin
$monitor("%d %d %d %d",PA,PB,PC,PD);
#5
CS=0;
RESET=0;
 D[7]=0;

 D[7:1]=8'b0000000;
D[0]=1;
#5
 D[7:1]=8'b0000001;
D[0]=1;
#5
D[7:1]=8'bzzzz010;
D[0]=1;
#5
D[7:1]=8'bzzzz011;
D[0]=1;
#5
D[7:1]=8'bzzzz100;
D[0]=1;
#5
 D[7:1]=8'bzzzz101;
D[0]=1;
#5
 D[7:1]=8'bzzzz110;
D[0]=1;
#5
D[7:1]=8'bzzzz111;
D[0]=1;
#5

D[7]=1;
 RD=0;
WR=1;
sel=00;
 A=8'b0000_0100;
#5
sel=01;
B=8'b0000_0100;
#5
sel=10;
C=8'b0000_0100;
#5
RD=1;
WR=0;
sel=00;
D=8'b0000_0001;
#5
sel=01;
D=8'b0000_0001;
#5
sel=10;
D=8'b0000_0001;
#5
sel=11;
D=8'b0000_0001;
#5 
RESET=1;
end
PPI myppi(RESET,CS,RD,WR,sel,PA,PB,PC,PD);

endmodule
	











