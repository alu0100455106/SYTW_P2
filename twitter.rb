# encoding: utf-8
require 'twitter'
require './configure'
require 'rack'

class HelloWorld

  
  def call env
    req = Rack::Request.new(env)
    res = Rack::Response.new 
    
    res['Content-Type'] = 'text/html'
    
    name = (req["username"] && req["username"] != '') ? req["username"] : ''
    tuits1 = (!name.empty?) ? valido?(name) : "No se ha introducido usuario"	    
    tuits2 = (!name.empty?) ? muestra1(name) : ""			
    tuits3 = (!name.empty?) ? muestra2(name) : ""			
    
    res.write <<-"EOS"
      <!DOCTYPE HTML>
      <html>
	<head>
	  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        </head>
        
	<title>Rack::Response</title>
        
	<body>
	      <h2><pre>  Introduzca el username de la persona a buscar</h2></pre>
	      <form action="/" method="post">
		  <pre>  Username: <input type="text" name="username" autofocus><br></pre>
		  		  
		  <pre>  <input type="submit" value="Aceptar"></pre>
	      </form>        

	      <p>***********************************************************************************</p>
	      <pre>
	      <h3>                        @#{name}</h3>
	      <p><h5>    Ultimo tweet:</h5> #{tuits1}   </p>
	      <p><h5>    Penúltimo tweet:</h5> #{tuits2}   </p>
	      <p><h5>    Antepenúltimo tweet:</h5> #{tuits3}   </p>
	     </pre>
	</body>
      </html>
    EOS
    res.finish
  end
  
  
  def valido?(username)
    begin
	num = 0
	Twitter.user_timeline(username).fetch(num).text
    rescue
	"Usuario no válido"
    end
  end
  
  def muestra1(username)
      Twitter.user_timeline(username).fetch(1).text
  end  

  def muestra2(username)
      Twitter.user_timeline(username).fetch(2).text
  end  
end



Rack::Server.start(
  :app => HelloWorld.new,
  :Port => '9292',
  :server => 'thin'
)

