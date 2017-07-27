from pylab import *
x1=arange(20,100,3)
#x1= arange(65,66,1)
theta=[]
vel=[]
X=[]
Y=[]
#x2=[z**2 for z in x]
s=1
i=1
y_1=arange(20,100,2)
#y_1= arange(115,116,1)
for j in x1:
  x=arange(0,2*j+3,4)
  r=float(2*j)
  #for a in range(5,80):
    #y1=j*j/(4*a)
  for y1 in y_1:
    a=j*j/(4*y1) 
    #if y1<100:
    if a>0:
      xdiff=[(d-j)*(d-j)/(4*a) for d in x]
		
      y=[y1-xdif for xdif in xdiff]
   
      Y.append(y1)
      X.append(r)
      theta.append(math.degrees(math.atan((4*y1)/r)))
		
      plt.plot(x,y,marker='o',ms=10.0)
      ylim([0,100])
      xlim([0,200])
      fig = matplotlib.pyplot.gcf()
      fig.set_size_inches(4,4)
      frame1=plt.gca()
      frame1.axes.get_xaxis().set_visible(False)
      frame1.axes.get_yaxis().set_visible(False)
      vel.append(math.sqrt(9.8*(16*y1*y1+r*r)/(8*y1)))
#plt.axis('off')
      name=str(s)+'.png'
      plt.savefig(name,dpi=50)
	   
      s=s+1
      close()
      plt.show()            
      f=open("vel","w")
      vel1=["%.2f" % x for x in vel]
      f.write("\n".join( x for x in vel1))
      t=open("theta","w")
      thet1=["%.4f" % x for x in theta]
      t.write("\n".join( x for x in thet1))
      f=open("X","w")
      vel1=["%f" % x for x in X]
      f.write("\n".join( x for x in vel1))
      t=open("Y","w")
      vel2=["%f" % x for x in Y]
      t.write("\n".join( x for x in vel2))


            
