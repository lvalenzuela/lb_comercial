<!DOCTYPE html>
<html lang="en">
<head>
<title>Around the World</title>
<meta charset="utf-8">
<link rel="stylesheet" href="css/reset.css" type="text/css" media="all">
<link rel="stylesheet" href="css/layout.css" type="text/css" media="all">
<link rel="stylesheet" href="css/style.css" type="text/css" media="all">
<script type="text/javascript" src="js/jquery-1.4.2.js" ></script>
<script type="text/javascript" src="js/cufon-yui.js"></script>
<script type="text/javascript" src="js/cufon-replace.js"></script>
<script type="text/javascript" src="js/Myriad_Pro_600.font.js"></script>
<!--[if lt IE 9]>
<script type="text/javascript" src="js/ie6_script_other.js"></script>
<script type="text/javascript" src="js/html5.js"></script>
<![endif]-->
</head>

<?
  $conexion = mysql_connect("houston.longbourn.cl", "longbourn_sys", "i1dont2know3");
  //Aquí hay que sustituir la el nombre de la base de datos
  mysql_select_db("wordpress_testing", $conexion);
  $modalidad_lugar = addslashes( $_POST['modalidad_lugar'] ); 
  $modalidad_cantidad = addslashes( $_POST['modalidad_cantidad'] ); 
  $fecha_mes = addslashes( $_POST['fecha_mes'] ); 
  $fecha_quincena = addslashes( $_POST['fecha_quincena'] ); 
  $tipo_curso = addslashes( $_POST['tipo_curso'] ); 
  $verificador = addslashes( $_POST['verificador'] ); 
?>


<body id="page1">
<!-- START PAGE SOURCE -->
<div class="extra">
  <div class="main">
    <header>

      <div class="wrapper">
        <h1><a href="index.php" id="logo">Longbourn Institute</a></h1>

        <div class="right">
          <div class="wrapper">
            <form id="search" action="#" method="post">
              <div class="bg">
                <input type="submit" class="submit" value="">
                <input type="text" class="input">
              </div>
            </form>
          </div>

          <div class="wrapper">
            <nav>
              <ul id="top_nav">
                <li><a href="#">Reg&iacutestrate</a></li>
                <li><a href="#">Ingresa</a></li>
                <li><a href="#">Ayuda</a></li>
              </ul>
            </nav>
          </div>

          <div class="wrapper">
            <nav>
            <br>
              <ul id="top_navi">
                <li><a href="#">Prueba de diagn&oacutestico</a></li>
              </ul>
            </nav>
          </div>
        </div>


      </div>
      <nav>
        <ul id="menu">
          <li><a href="index.html" class="nav1">Home</a></li>
          <li><a href="about.html" class="nav2">About Us </a></li>
          <li><a href="tours.html" class="nav3">Our Tours</a></li>
          <li><a href="destinations.html" class="nav4">Destinations</a></li>
          <li class="end"><a href="contacts.html" class="nav5">Contacts</a></li>
        </ul>
      </nav>
      <article class="col1">


        <ul class="tabs">
          <li><a href="#" class="active">Busca tu curso ideal</a></li>
        </ul>


        <div class="tabs_cont">
          
            <div class="bg">

              <div class="wrapper">

              <span>
                <form id='form_1' name='formulario_hunter' method='post' action='hunter.php'> 

                <table BORDER=0  align=center border=0 bgcolor="#C2C2C2">


                <tr><td>Fecha </td> 
                  <td height=30 align=center><select name='fecha_mes'>
                  <option value='Enero'>Enero</option>
                  <option value='Febrero'>Febrero</option>
                  <option value='Marzo'>Marzo</option>
                  <option value='Abril'>Abril</option>
                  <option value='Mayo'>Mayo</option>
                  <option value='Junio'>Junio</option>
                  <option value='Julio'>Julio</option>
                  <option value='Agosto'>Agosto</option>
                  <option value='Septiembre'>Septiembre</option>
                  <option value='Octubre'>Octubre</option>
                  <option value='Noviembre'>Noviembre</option>
                  <option value='Diciembre'>Diciembre</option>
                  
                  </select> </td>
                 
                  
                  <td><input type="radio" name="fecha_quincena" id="fecha_quincena_1-15" value="1" checked>
                        1era quincena<br>
                        
                  <input type="radio" name="fecha_quincena" id="fecha_quincena_16-31" value="2">
                        2da quincena
                      
                </td> 
                </tr>

                <tr ><td>Lugar </td> <td height=70>

                    <input type="radio" name="modalidad_lugar" id="modalidad_lugar_sede" value="Sede" checked>
                    Sede <br>
                    <input type="radio" name="modalidad_lugar" id="modalidad_lugar_oficina" value="Oficina">
                    Oficina

                </td> </tr>

                <tr><td>Cantidad </td> <td>
                  
                  <input type="radio" name="modalidad_cantidad" id="modalidad_cantidad_grupal" value="Grupal" checked>
                      Grupal <br>
                      <input type="radio" name="modalidad_cantidad" id="modalidad_cantidad_individual" value="Individual">
                      Individual


                <tr> <td>
                <br>Tipo de curso:</td><td>
                    <br> <input type="radio" name="tipo_curso" id="tipo_curso_Inglés" value="Inglés" checked>
                    Inglés <br>
                    <input type="radio" name="tipo_curso" id="tipo_curso_Tests" value="Tests">
                    Testsy
                </tr> </td>


                <input type="hidden" name="verificador" id="verificador" value="1" />

                <tr> <td> </td> <td> <br> <input type='submit' value='Buscar Cursos'></form> </td> </tr>

                </table>

                </span> 
                
                


            </div>
          
        </div>
      </article>
      <article class="col1 pad_left1">
        <div class="text"> <img src="images/text1.jpg" alt="">
          <h2>The Best Offers</h2>
          <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.</p>
          <a href="#" class="button">Read More</a> </div>
      </article>
      <div class="img"><img src="" alt=""></div>
    </header>
    <section id="content">
      <article class="col1">
        <h3>Hot Travel</h3>
        <div class="pad">
          <div class="wrapper under">
            <figure class="left marg_right1"><img src="images/page1_img1.jpg" alt=""></figure>
            <p class="pad_bot2"><strong>Italy<br>
              Holidays</strong></p>
            <p class="pad_bot2">Lorem ipsum dolor sit amet, consect etuer adipiscing.</p>
            <a href="#" class="marker_1"></a> </div>
          <div class="wrapper under">
            <figure class="left marg_right1"><img src="images/page1_img2.jpg" alt=""></figure>
            <p class="pad_bot2"><strong>Philippines<br>
              Travel</strong></p>
            <p class="pad_bot2">Lorem ipsum dolor sit amet, consect etuer adipiscing.</p>
            <a href="#" class="marker_1"></a> </div>
          <div class="wrapper">
            <figure class="left marg_right1"><img src="images/page1_img3.jpg" alt=""></figure>
            <p class="pad_bot2"><strong>Cruise<br>
              Holidays</strong></p>
            <p class="pad_bot2">Lorem ipsum dolor sit amet, consect etuer adipiscing.</p>
            <a href="#" class="marker_1"></a> </div>
        </div>
      </article>
      <article class="col2 pad_left1">
        <h2>Popular Places</h2>
        <div class="wrapper under">
          <figure class="left marg_right1"><img src="images/page1_img4.jpg" alt=""></figure>
          <p class="pad_bot2"><strong>Hotel du Havre</strong></p>
          <p class="pad_bot2">Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. </p>
          <p class="pad_bot2"><strong>Nemo enim ipsam voluptatem</strong> quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur.</p>
          <a href="#" class="marker_2"></a> </div>
        <div class="wrapper">
          <figure class="left marg_right1"><img src="images/page1_img5.jpg" alt=""></figure>
          <p class="pad_bot2"><strong>Hotel Vacance</strong></p>
          <p class="pad_bot2">At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa.</p>
          <p class="pad_bot2">Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda.</p>
          <a href="#" class="marker_2"></a> </div>
      </article>
    </section>
  </div>
  <div class="block"></div>
</div>
<div class="body1">
  <div class="main">
    <footer>
      <div class="footerlink">
        <p class="lf">Copyright &copy; 2010 <a href="#">SiteName</a> - All Rights Reserved</p>
        <p class="rf"><a href="http://all-free-download.com/free-website-templates/">Free CSS Templates</a> by <a href="http://www.templatemonster.com/">TemplateMonster</a></p>
        <div style="clear:both;"></div>
      </div>
    </footer>
  </div>
</div>
<script type="text/javascript"> Cufon.now(); </script>
<!-- END PAGE SOURCE -->
<div align=center>This template  downloaded form <a href='http://all-free-download.com/free-website-templates/'>free website templates</a></div></body>
</html>