PGDMP     *    	                w            db_proyecta_peru    9.6.9    9.6.9 `    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    16734    db_proyecta_peru    DATABASE     �   CREATE DATABASE db_proyecta_peru WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Peru.1252' LC_CTYPE = 'Spanish_Peru.1252';
     DROP DATABASE db_proyecta_peru;
             admin_proyecta_peru    false                        2615    16785    Gestion    SCHEMA        CREATE SCHEMA "Gestion";
    DROP SCHEMA "Gestion";
             admin_proyecta_peru    false                        2615    16735 	   Seguridad    SCHEMA        CREATE SCHEMA "Seguridad";
    DROP SCHEMA "Seguridad";
             admin_proyecta_peru    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    12387    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �           1247    23871 	   ty_mis_pl    TYPE     �   CREATE TYPE "Gestion".ty_mis_pl AS (
	"idProyectoLey" integer,
	nombre character varying,
	titulo character varying,
	"tipoSeccion" character varying,
	"descripcionSeccion" character varying
);
    DROP TYPE "Gestion".ty_mis_pl;
       Gestion       postgres    false    8                       1247    23821    ty_resultado    TYPE     W   CREATE TYPE "Gestion".ty_resultado AS (
	codigo integer,
	mensaje character varying
);
 "   DROP TYPE "Gestion".ty_resultado;
       Gestion       postgres    false    8            v           1247    17240    ty_login    TYPE     "  CREATE TYPE "Seguridad".ty_login AS (
	"idUsuario" integer,
	username character varying,
	password character varying,
	estado integer,
	nombre character varying,
	"apellidoPaterno" character varying,
	"apellidoMaterno" character varying,
	"idRol" integer,
	"nombreRol" character varying
);
     DROP TYPE "Seguridad".ty_login;
    	   Seguridad       admin_proyecta_peru    false    4            y           1247    17222    ty_resultado    TYPE     Y   CREATE TYPE "Seguridad".ty_resultado AS (
	codigo integer,
	mensaje character varying
);
 $   DROP TYPE "Seguridad".ty_resultado;
    	   Seguridad       admin_proyecta_peru    false    4            s           1247    17215    ty_roles    TYPE     a   CREATE TYPE "Seguridad".ty_roles AS (
	id integer,
	nombre character varying,
	estado integer
);
     DROP TYPE "Seguridad".ty_roles;
    	   Seguridad       admin_proyecta_peru    false    4            |           1247    17236    ty_usuarios    TYPE     J  CREATE TYPE "Seguridad".ty_usuarios AS (
	dni character varying,
	nombre character varying,
	"apellidoPaterno" character varying,
	"apellidoMaterno" character varying,
	"fhNacimiento" character varying,
	"idUsuario" integer,
	"nombreUsuario" character varying,
	estado integer,
	"idRol" integer,
	"nombreRol" character varying
);
 #   DROP TYPE "Seguridad".ty_usuarios;
    	   Seguridad       admin_proyecta_peru    false    4            �            1255    23822 p   fn_gs_insert_proyecto_ley(character varying, character varying, character varying, integer, integer, text, text)    FUNCTION     �  CREATE FUNCTION "Gestion".fn_gs_insert_proyecto_ley(p_nombre character varying, p_titulo character varying, p_usuario_ins character varying, p_id_usuario integer, p_id_categoria integer, p_objeto_ley text, p_fundamento_ley text) RETURNS SETOF "Gestion".ty_resultado
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_va_return "Gestion".ty_resultado%rowtype;
	v_nombre character varying := p_nombre;
	v_titulo character varying := p_titulo;
	v_usuario_ins character varying := p_usuario_ins;
	v_id_usuario integer := p_id_usuario;
	v_id_categoria integer := p_id_categoria;
	v_objeto_ley text := p_objeto_ley;
	v_fundamento_ley text := p_fundamento_ley;

	v_id_proyecto_ley integer := null;	
BEGIN
	insert into "Gestion".tb_proyecto_ley(nombre, titulo, fh_ins, usuario_ins, fl_estado, id_usuario, id_categoria)
		values (v_nombre, v_titulo, now(), v_usuario_ins, '1', v_id_usuario, v_id_categoria) returning id into v_id_proyecto_ley;

	insert into "Gestion".tb_seccion(nombre, descripcion, tipo_seccion, fh_ins, usuario_ins, fl_estado, id_proyecto_ley)
		values ('Objeto de la Ley', v_objeto_ley, 'O', now(), v_usuario_ins, '1', v_id_proyecto_ley);

	insert into "Gestion".tb_seccion(nombre, descripcion, tipo_seccion, fh_ins, usuario_ins, fl_estado, id_proyecto_ley)
		values ('Fundamento de la Ley', v_fundamento_ley, 'F', now(), v_usuario_ins, '1', v_id_proyecto_ley);
	
	select 1, 'Ok.' into v_va_return;
return next v_va_return;
END;
$$;
 �   DROP FUNCTION "Gestion".fn_gs_insert_proyecto_ley(p_nombre character varying, p_titulo character varying, p_usuario_ins character varying, p_id_usuario integer, p_id_categoria integer, p_objeto_ley text, p_fundamento_ley text);
       Gestion       postgres    false    8    1    639            �            1255    23872 %   fn_gs_select_mis_pl(integer, integer)    FUNCTION       CREATE FUNCTION "Gestion".fn_gs_select_mis_pl(p_id_usuario integer, p_fl_estado integer) RETURNS SETOF "Gestion".ty_mis_pl
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_va_return "Gestion".ty_mis_pl%rowtype;
	v_id_usuario integer := p_id_usuario;
	v_fl_estado integer := p_fl_estado;

	v_sql text := '';
	
BEGIN
	v_sql = '	select 	pl.id,
				pl.nombre,
				pl.titulo,
				s.tipo_seccion,
				s.descripcion
			from "Gestion".tb_proyecto_ley pl
			inner join "Gestion".tb_seccion s on pl.id = s.id_proyecto_ley
			where id_usuario = ' || v_id_usuario;
			
	if v_fl_estado is not null then
		v_sql = v_sql || ' and fl_estado = ''' || v_fl_estado || '''';
	end if;
	
	for v_va_return in
		execute v_sql
	loop 
		return next v_va_return; 
	end loop ;
	return;
END
$$;
 X   DROP FUNCTION "Gestion".fn_gs_select_mis_pl(p_id_usuario integer, p_fl_estado integer);
       Gestion       postgres    false    647    1    8            �            1255    17227    fn_sg_delete_rol(integer)    FUNCTION     �  CREATE FUNCTION "Seguridad".fn_sg_delete_rol(p_id_rol integer) RETURNS "Seguridad".ty_resultado
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_va_return "Seguridad".ty_resultado%rowtype;
	v_id_rol integer := p_id_rol;
BEGIN
	if(select id from "Seguridad".tb_rol where id = v_id_rol) is not null then
		if (select id from "Seguridad".tb_usuario where id_rol = v_id_rol) is null then
			delete from "Seguridad".tb_rol where id = v_id_rol;
			
			select 1, 'Ok.' into v_va_return;	
		else
			select 0, 'El rol tiene usuarios asignados, no se puede eliminar.' into v_va_return;	
		end if;
	else
		select 0, 'El rol ingresado no existe.' into v_va_return;
	end if;
	
RETURN v_va_return;
END;
$$;
 >   DROP FUNCTION "Seguridad".fn_sg_delete_rol(p_id_rol integer);
    	   Seguridad       admin_proyecta_peru    false    1    633    4            �            1255    17224 6   fn_sg_insert_rol(character varying, character varying)    FUNCTION     �  CREATE FUNCTION "Seguridad".fn_sg_insert_rol(p_nombre character varying, p_usuario_ins character varying) RETURNS SETOF "Seguridad".ty_resultado
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_va_return "Seguridad".ty_resultado%rowtype;
	v_nombre character varying:= p_nombre;
	v_usuario_ins character varying := p_usuario_ins;	
BEGIN
	if (select id from "Seguridad".tb_rol where upper(nombre) = upper(v_nombre)) is null then
	
		insert into"Seguridad".tb_rol(nombre, fh_ins, usuario_ins, fl_estado)
			values (v_nombre, now(), v_usuario_ins, '1');
	
		select 1, 'Ok.' into v_va_return;
	else
		select 0, 'Nombre Rol ya existe.' into v_va_return;
	end if;
return next v_va_return;
END;
$$;
 i   DROP FUNCTION "Seguridad".fn_sg_insert_rol(p_nombre character varying, p_usuario_ins character varying);
    	   Seguridad       admin_proyecta_peru    false    633    4    1            �            1255    17223 �   fn_sg_insert_usuario_persona(character varying, character varying, character varying, character varying, character varying, character varying, date, integer, character varying)    FUNCTION     �  CREATE FUNCTION "Seguridad".fn_sg_insert_usuario_persona(p_dni character varying, p_nombre character varying, p_apellido_paterno character varying, p_apellido_materno character varying, p_email character varying, p_password_usuario character varying, p_fh_nacimiento date, p_id_rol integer, p_usuario_ins character varying) RETURNS SETOF "Seguridad".ty_resultado
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_va_return "Seguridad".ty_resultado%rowtype;
	v_dni character varying:= p_dni;
	v_nombre character varying:= p_nombre;
	v_apellido_paterno character varying:= p_apellido_paterno;
	v_apellido_materno character varying:= p_apellido_materno;
	v_email character varying:= p_email;
	v_password_usuario character varying:= p_password_usuario;
	v_fh_nacimiento timestamp:= p_fh_nacimiento::timestamp;
	v_id_rol integer:= p_id_rol;
	v_usuario_ins character varying := p_usuario_ins;	
BEGIN

	if (select dni from "Seguridad".tb_persona where dni = v_dni) is null then
		if (select id from "Seguridad".tb_usuario where nombre_usuario = v_email) is null then
			--Registrar Primero en la tabla Persona
			insert into "Seguridad".tb_persona(dni, nombre, apellido_paterno, apellido_materno, email, edad, fh_nacimiento, fh_ins, usuario_ins, fl_estado)
				values (v_dni, v_nombre, v_apellido_paterno, v_apellido_materno, v_email, (select date_part('year', age(v_fh_nacimiento)))::integer,
					v_fh_nacimiento, now(), v_usuario_ins, '1');

			--Registrar luego en la tabla Usuario
			insert into "Seguridad".tb_usuario(nombre_usuario, password_usuario, fh_ins, usuario_ins, fl_estado, dni_persona, id_rol)
				values (v_email, v_password_usuario, now(), v_usuario_ins, '1', v_dni, v_id_rol);
			
			select 1, 'Ok.' into v_va_return;
		else
			select 0, 'Ya se ha registrado un nombre de usuario con este email.' into v_va_return;
		end if;
	else
		select 0, 'Ya se ha registrado un usuario con este DNI.' into v_va_return;
	end if;
	
return next v_va_return;
END;
$$;
 C  DROP FUNCTION "Seguridad".fn_sg_insert_usuario_persona(p_dni character varying, p_nombre character varying, p_apellido_paterno character varying, p_apellido_materno character varying, p_email character varying, p_password_usuario character varying, p_fh_nacimiento date, p_id_rol integer, p_usuario_ins character varying);
    	   Seguridad       admin_proyecta_peru    false    4    633    1            �            1255    17241    fn_sg_login(character varying)    FUNCTION     {  CREATE FUNCTION "Seguridad".fn_sg_login(p_username character varying) RETURNS SETOF "Seguridad".ty_login
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_va_return "Seguridad".ty_login%rowtype;
	v_username character varying := p_username;
BEGIN
	for v_va_return in
		select u.id, nombre_usuario, u.password_usuario, u.fl_estado, p.nombre, apellido_paterno, apellido_materno, r.id, r.nombre
		from "Seguridad".tb_usuario u
		inner join "Seguridad".tb_persona p on p.dni = u.dni_persona
		inner join "Seguridad".tb_rol r on r.id = u.id_rol
		and nombre_usuario = v_username
	loop 
		return next v_va_return; 
	end loop ;
END
$$;
 E   DROP FUNCTION "Seguridad".fn_sg_login(p_username character varying);
    	   Seguridad       admin_proyecta_peru    false    630    1    4            �            1255    17216    fn_sg_select_roles()    FUNCTION     @  CREATE FUNCTION "Seguridad".fn_sg_select_roles() RETURNS SETOF "Seguridad".ty_roles
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_va_return "Seguridad".ty_roles%rowtype;    
BEGIN
	for v_va_return in
		select id, nombre, fl_estado 
		from "Seguridad".tb_rol
	loop 
		return next v_va_return; 
	end loop ;
END
$$;
 0   DROP FUNCTION "Seguridad".fn_sg_select_roles();
    	   Seguridad       admin_proyecta_peru    false    4    1    627            �            1255    17237    fn_sg_select_usuarios()    FUNCTION     $  CREATE FUNCTION "Seguridad".fn_sg_select_usuarios() RETURNS SETOF "Seguridad".ty_usuarios
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_va_return "Seguridad".ty_usuarios%rowtype;    
BEGIN
	for v_va_return in
		select dni, p.nombre, apellido_paterno, apellido_materno, fh_nacimiento, u.id, nombre_usuario, u.fl_estado, id_rol, r.nombre
		from "Seguridad".tb_persona p
		inner join "Seguridad".tb_usuario u on p.dni = u.dni_persona
		inner join "Seguridad".tb_rol r on r.id = u.id_rol
	loop 
		return next v_va_return; 
	end loop ;
END
$$;
 3   DROP FUNCTION "Seguridad".fn_sg_select_usuarios();
    	   Seguridad       admin_proyecta_peru    false    1    636    4            �            1255    17226 ?   fn_sg_update_rol(integer, character varying, character varying)    FUNCTION     �  CREATE FUNCTION "Seguridad".fn_sg_update_rol(p_id_rol integer, p_nombre character varying, p_usuario_mod character varying) RETURNS "Seguridad".ty_resultado
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_va_return "Seguridad".ty_resultado%rowtype;
	v_id_rol integer := p_id_rol;
	v_nombre character varying := p_nombre;
	v_usuario_mod character varying:= p_usuario_mod;
	
BEGIN

	if (select id from "Seguridad".tb_rol where upper(nombre) = upper(v_nombre) and id <> v_id_rol) is null then
		update "Seguridad".tb_rol
		set nombre=v_nombre, fh_mod=now(), usuario_mod=v_usuario_mod
		where id = v_id_rol;
		
		select 1, 'Ok.' into v_va_return;
	else
		select 0, 'Este nombre de Rol ya existe.' into v_va_return;
	end if;

RETURN v_va_return;
END;
$$;
 {   DROP FUNCTION "Seguridad".fn_sg_update_rol(p_id_rol integer, p_nombre character varying, p_usuario_mod character varying);
    	   Seguridad       postgres    false    4    633    1            �            1259    16799    tb_categoria    TABLE       CREATE TABLE "Gestion".tb_categoria (
    id integer NOT NULL,
    nombre character varying NOT NULL,
    fh_ins timestamp without time zone,
    fh_mod timestamp without time zone,
    usuario_ins character varying,
    usuario_mod character varying,
    fl_estado bit(1)
);
 #   DROP TABLE "Gestion".tb_categoria;
       Gestion         admin_proyecta_peru    false    8            �           0    0    COLUMN tb_categoria.fl_estado    COMMENT     [   COMMENT ON COLUMN "Gestion".tb_categoria.fl_estado IS 'Valores:

1 = activo
0 = inactivo';
            Gestion       admin_proyecta_peru    false    193            �            1259    16797    categoria_id_seq    SEQUENCE     |   CREATE SEQUENCE "Gestion".categoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE "Gestion".categoria_id_seq;
       Gestion       admin_proyecta_peru    false    193    8            �           0    0    categoria_id_seq    SEQUENCE OWNED BY     N   ALTER SEQUENCE "Gestion".categoria_id_seq OWNED BY "Gestion".tb_categoria.id;
            Gestion       admin_proyecta_peru    false    192            �            1259    16831    tb_comentario    TABLE     G  CREATE TABLE "Gestion".tb_comentario (
    id integer NOT NULL,
    nombre character varying,
    descripcion character varying,
    fh_ins timestamp without time zone,
    fh_mod timestamp without time zone,
    usuario_ins character varying,
    usuario_mod character varying,
    fl_estado bit(1),
    id_usuario integer
);
 $   DROP TABLE "Gestion".tb_comentario;
       Gestion         admin_proyecta_peru    false    8            �           0    0    COLUMN tb_comentario.fl_estado    COMMENT     \   COMMENT ON COLUMN "Gestion".tb_comentario.fl_estado IS 'Valores:

1 = activo
0 = inactivo';
            Gestion       admin_proyecta_peru    false    197            �            1259    16829    comentario_id_seq    SEQUENCE     }   CREATE SEQUENCE "Gestion".comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE "Gestion".comentario_id_seq;
       Gestion       admin_proyecta_peru    false    197    8            �           0    0    comentario_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE "Gestion".comentario_id_seq OWNED BY "Gestion".tb_comentario.id;
            Gestion       admin_proyecta_peru    false    196            �            1259    16810    tb_proyecto_ley    TABLE     ^  CREATE TABLE "Gestion".tb_proyecto_ley (
    id integer NOT NULL,
    nombre character varying,
    titulo character varying,
    fh_ins timestamp without time zone,
    fh_mod timestamp without time zone,
    usuario_ins character varying,
    usuario_mod character varying,
    fl_estado bit(1),
    id_usuario integer,
    id_categoria integer
);
 &   DROP TABLE "Gestion".tb_proyecto_ley;
       Gestion         admin_proyecta_peru    false    8            �           0    0     COLUMN tb_proyecto_ley.fl_estado    COMMENT     ^   COMMENT ON COLUMN "Gestion".tb_proyecto_ley.fl_estado IS 'Valores:

1 = activo
0 = inactivo';
            Gestion       admin_proyecta_peru    false    195            �            1259    16808    proyecto_ley_id_seq    SEQUENCE        CREATE SEQUENCE "Gestion".proyecto_ley_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE "Gestion".proyecto_ley_id_seq;
       Gestion       admin_proyecta_peru    false    195    8            �           0    0    proyecto_ley_id_seq    SEQUENCE OWNED BY     T   ALTER SEQUENCE "Gestion".proyecto_ley_id_seq OWNED BY "Gestion".tb_proyecto_ley.id;
            Gestion       admin_proyecta_peru    false    194            �            1259    23849    seccion_id_seq    SEQUENCE     z   CREATE SEQUENCE "Gestion".seccion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "Gestion".seccion_id_seq;
       Gestion       postgres    false    8            �            1259    16864    tb_seguimiento    TABLE     0  CREATE TABLE "Gestion".tb_seguimiento (
    id integer NOT NULL,
    nombre character varying,
    descripcion character varying,
    fh_ins timestamp without time zone,
    fh_mod timestamp without time zone,
    usuario_ins character varying,
    usuario_mod character varying,
    fl_estado bit(1)
);
 %   DROP TABLE "Gestion".tb_seguimiento;
       Gestion         admin_proyecta_peru    false    8            �           0    0    COLUMN tb_seguimiento.fl_estado    COMMENT     ]   COMMENT ON COLUMN "Gestion".tb_seguimiento.fl_estado IS 'Valores:

1 = activo
0 = inactivo';
            Gestion       admin_proyecta_peru    false    199            �            1259    16862    seguimiento_id_seq    SEQUENCE     ~   CREATE SEQUENCE "Gestion".seguimiento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE "Gestion".seguimiento_id_seq;
       Gestion       admin_proyecta_peru    false    8    199            �           0    0    seguimiento_id_seq    SEQUENCE OWNED BY     R   ALTER SEQUENCE "Gestion".seguimiento_id_seq OWNED BY "Gestion".tb_seguimiento.id;
            Gestion       admin_proyecta_peru    false    198            �            1259    23851 
   tb_seccion    TABLE     �  CREATE TABLE "Gestion".tb_seccion (
    id integer DEFAULT nextval('"Gestion".seccion_id_seq'::regclass) NOT NULL,
    nombre character varying,
    descripcion character varying,
    tipo_seccion character(1),
    fh_ins timestamp without time zone,
    fh_mod timestamp without time zone,
    usuario_ins character varying,
    usuario_mod character varying,
    fl_estado bit(1),
    id_proyecto_ley integer
);
 !   DROP TABLE "Gestion".tb_seccion;
       Gestion         admin_proyecta_peru    false    206    8            �           0    0    COLUMN tb_seccion.tipo_seccion    COMMENT     p   COMMENT ON COLUMN "Gestion".tb_seccion.tipo_seccion IS 'Valores:

O: Objeto de la Ley
F: Fundamento de la Ley';
            Gestion       admin_proyecta_peru    false    207            �           0    0    COLUMN tb_seccion.fl_estado    COMMENT     Y   COMMENT ON COLUMN "Gestion".tb_seccion.fl_estado IS 'Valores:

1 = activo
0 = inactivo';
            Gestion       admin_proyecta_peru    false    207            �            1259    16886    tb_seguimiento_proyecto_ley    TABLE     .  CREATE TABLE "Gestion".tb_seguimiento_proyecto_ley (
    id_seguimiento integer NOT NULL,
    id_proyecto_ley integer NOT NULL,
    fh_ins timestamp without time zone,
    fh_mod timestamp without time zone,
    usuario_ins character varying,
    usuario_mod character varying,
    fl_estado bit(1)
);
 2   DROP TABLE "Gestion".tb_seguimiento_proyecto_ley;
       Gestion         admin_proyecta_peru    false    8            �           0    0 ,   COLUMN tb_seguimiento_proyecto_ley.fl_estado    COMMENT     j   COMMENT ON COLUMN "Gestion".tb_seguimiento_proyecto_ley.fl_estado IS 'Valores:

1 = activo
0 = inactivo';
            Gestion       admin_proyecta_peru    false    200            �            1259    16738    tb_rol    TABLE       CREATE TABLE "Seguridad".tb_rol (
    id integer NOT NULL,
    nombre character varying,
    fh_ins timestamp without time zone,
    fh_mod timestamp without time zone,
    usuario_ins character varying,
    usuario_mod character varying,
    fl_estado bit(1)
);
    DROP TABLE "Seguridad".tb_rol;
    	   Seguridad         admin_proyecta_peru    false    4            �           0    0    COLUMN tb_rol.fl_estado    COMMENT     W   COMMENT ON COLUMN "Seguridad".tb_rol.fl_estado IS 'Valores:

1 = activo
0 = inactivo';
         	   Seguridad       admin_proyecta_peru    false    188            �            1259    16736 
   rol_id_seq    SEQUENCE     x   CREATE SEQUENCE "Seguridad".rol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE "Seguridad".rol_id_seq;
    	   Seguridad       admin_proyecta_peru    false    4    188            �           0    0 
   rol_id_seq    SEQUENCE OWNED BY     F   ALTER SEQUENCE "Seguridad".rol_id_seq OWNED BY "Seguridad".tb_rol.id;
         	   Seguridad       admin_proyecta_peru    false    187            �            1259    16747 
   tb_persona    TABLE     �  CREATE TABLE "Seguridad".tb_persona (
    dni character varying(8) NOT NULL,
    nombre character varying NOT NULL,
    apellido_paterno character varying NOT NULL,
    apellido_materno character varying NOT NULL,
    email character varying,
    edad integer,
    fh_nacimiento date,
    fh_ins timestamp without time zone,
    fh_mod timestamp without time zone,
    usuario_ins character varying,
    usuario_mod character varying,
    fl_estado bit(1)
);
 #   DROP TABLE "Seguridad".tb_persona;
    	   Seguridad         admin_proyecta_peru    false    4            �           0    0    COLUMN tb_persona.fl_estado    COMMENT     [   COMMENT ON COLUMN "Seguridad".tb_persona.fl_estado IS 'Valores:

1 = activo
0 = inactivo';
         	   Seguridad       admin_proyecta_peru    false    189            �            1259    16766 
   tb_usuario    TABLE     r  CREATE TABLE "Seguridad".tb_usuario (
    id integer NOT NULL,
    nombre_usuario character varying,
    password_usuario character varying,
    fh_ins timestamp without time zone,
    fh_mod timestamp without time zone,
    usuario_ins character varying,
    usuario_mod character varying,
    fl_estado bit(1),
    dni_persona character varying,
    id_rol integer
);
 #   DROP TABLE "Seguridad".tb_usuario;
    	   Seguridad         admin_proyecta_peru    false    4            �           0    0    COLUMN tb_usuario.fl_estado    COMMENT     Z   COMMENT ON COLUMN "Seguridad".tb_usuario.fl_estado IS 'Valores:
1 = activo
0 = inactivo';
         	   Seguridad       admin_proyecta_peru    false    191            �            1259    16764    usuario_id_seq    SEQUENCE     |   CREATE SEQUENCE "Seguridad".usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE "Seguridad".usuario_id_seq;
    	   Seguridad       admin_proyecta_peru    false    191    4            �           0    0    usuario_id_seq    SEQUENCE OWNED BY     N   ALTER SEQUENCE "Seguridad".usuario_id_seq OWNED BY "Seguridad".tb_usuario.id;
         	   Seguridad       admin_proyecta_peru    false    190            +           2604    16802    tb_categoria id    DEFAULT     u   ALTER TABLE ONLY "Gestion".tb_categoria ALTER COLUMN id SET DEFAULT nextval('"Gestion".categoria_id_seq'::regclass);
 A   ALTER TABLE "Gestion".tb_categoria ALTER COLUMN id DROP DEFAULT;
       Gestion       admin_proyecta_peru    false    193    192    193            -           2604    16834    tb_comentario id    DEFAULT     w   ALTER TABLE ONLY "Gestion".tb_comentario ALTER COLUMN id SET DEFAULT nextval('"Gestion".comentario_id_seq'::regclass);
 B   ALTER TABLE "Gestion".tb_comentario ALTER COLUMN id DROP DEFAULT;
       Gestion       admin_proyecta_peru    false    197    196    197            ,           2604    16813    tb_proyecto_ley id    DEFAULT     {   ALTER TABLE ONLY "Gestion".tb_proyecto_ley ALTER COLUMN id SET DEFAULT nextval('"Gestion".proyecto_ley_id_seq'::regclass);
 D   ALTER TABLE "Gestion".tb_proyecto_ley ALTER COLUMN id DROP DEFAULT;
       Gestion       admin_proyecta_peru    false    194    195    195            .           2604    16867    tb_seguimiento id    DEFAULT     y   ALTER TABLE ONLY "Gestion".tb_seguimiento ALTER COLUMN id SET DEFAULT nextval('"Gestion".seguimiento_id_seq'::regclass);
 C   ALTER TABLE "Gestion".tb_seguimiento ALTER COLUMN id DROP DEFAULT;
       Gestion       admin_proyecta_peru    false    199    198    199            )           2604    16741 	   tb_rol id    DEFAULT     m   ALTER TABLE ONLY "Seguridad".tb_rol ALTER COLUMN id SET DEFAULT nextval('"Seguridad".rol_id_seq'::regclass);
 =   ALTER TABLE "Seguridad".tb_rol ALTER COLUMN id DROP DEFAULT;
    	   Seguridad       admin_proyecta_peru    false    187    188    188            *           2604    16769    tb_usuario id    DEFAULT     u   ALTER TABLE ONLY "Seguridad".tb_usuario ALTER COLUMN id SET DEFAULT nextval('"Seguridad".usuario_id_seq'::regclass);
 A   ALTER TABLE "Seguridad".tb_usuario ALTER COLUMN id DROP DEFAULT;
    	   Seguridad       admin_proyecta_peru    false    190    191    191            �           0    0    categoria_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('"Gestion".categoria_id_seq', 1, true);
            Gestion       admin_proyecta_peru    false    192            �           0    0    comentario_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('"Gestion".comentario_id_seq', 1, false);
            Gestion       admin_proyecta_peru    false    196            �           0    0    proyecto_ley_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('"Gestion".proyecto_ley_id_seq', 4, true);
            Gestion       admin_proyecta_peru    false    194            �           0    0    seccion_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('"Gestion".seccion_id_seq', 6, true);
            Gestion       postgres    false    206            �           0    0    seguimiento_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('"Gestion".seguimiento_id_seq', 1, false);
            Gestion       admin_proyecta_peru    false    198            �          0    16799    tb_categoria 
   TABLE DATA               j   COPY "Gestion".tb_categoria (id, nombre, fh_ins, fh_mod, usuario_ins, usuario_mod, fl_estado) FROM stdin;
    Gestion       admin_proyecta_peru    false    193   �       �          0    16831    tb_comentario 
   TABLE DATA               �   COPY "Gestion".tb_comentario (id, nombre, descripcion, fh_ins, fh_mod, usuario_ins, usuario_mod, fl_estado, id_usuario) FROM stdin;
    Gestion       admin_proyecta_peru    false    197   B�       �          0    16810    tb_proyecto_ley 
   TABLE DATA               �   COPY "Gestion".tb_proyecto_ley (id, nombre, titulo, fh_ins, fh_mod, usuario_ins, usuario_mod, fl_estado, id_usuario, id_categoria) FROM stdin;
    Gestion       admin_proyecta_peru    false    195   _�       �          0    23851 
   tb_seccion 
   TABLE DATA               �   COPY "Gestion".tb_seccion (id, nombre, descripcion, tipo_seccion, fh_ins, fh_mod, usuario_ins, usuario_mod, fl_estado, id_proyecto_ley) FROM stdin;
    Gestion       admin_proyecta_peru    false    207   ֙       �          0    16864    tb_seguimiento 
   TABLE DATA               y   COPY "Gestion".tb_seguimiento (id, nombre, descripcion, fh_ins, fh_mod, usuario_ins, usuario_mod, fl_estado) FROM stdin;
    Gestion       admin_proyecta_peru    false    199   R�       �          0    16886    tb_seguimiento_proyecto_ley 
   TABLE DATA               �   COPY "Gestion".tb_seguimiento_proyecto_ley (id_seguimiento, id_proyecto_ley, fh_ins, fh_mod, usuario_ins, usuario_mod, fl_estado) FROM stdin;
    Gestion       admin_proyecta_peru    false    200   o�       �           0    0 
   rol_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('"Seguridad".rol_id_seq', 2, true);
         	   Seguridad       admin_proyecta_peru    false    187            �          0    16747 
   tb_persona 
   TABLE DATA               �   COPY "Seguridad".tb_persona (dni, nombre, apellido_paterno, apellido_materno, email, edad, fh_nacimiento, fh_ins, fh_mod, usuario_ins, usuario_mod, fl_estado) FROM stdin;
 	   Seguridad       admin_proyecta_peru    false    189   ��       �          0    16738    tb_rol 
   TABLE DATA               f   COPY "Seguridad".tb_rol (id, nombre, fh_ins, fh_mod, usuario_ins, usuario_mod, fl_estado) FROM stdin;
 	   Seguridad       admin_proyecta_peru    false    188   7�       �          0    16766 
   tb_usuario 
   TABLE DATA               �   COPY "Seguridad".tb_usuario (id, nombre_usuario, password_usuario, fh_ins, fh_mod, usuario_ins, usuario_mod, fl_estado, dni_persona, id_rol) FROM stdin;
 	   Seguridad       admin_proyecta_peru    false    191   ě       �           0    0    usuario_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('"Seguridad".usuario_id_seq', 2, true);
         	   Seguridad       admin_proyecta_peru    false    190            7           2606    16807    tb_categoria categoria_pkey1 
   CONSTRAINT     ]   ALTER TABLE ONLY "Gestion".tb_categoria
    ADD CONSTRAINT categoria_pkey1 PRIMARY KEY (id);
 I   ALTER TABLE ONLY "Gestion".tb_categoria DROP CONSTRAINT categoria_pkey1;
       Gestion         admin_proyecta_peru    false    193    193            ;           2606    16839    tb_comentario comentario_pkey1 
   CONSTRAINT     _   ALTER TABLE ONLY "Gestion".tb_comentario
    ADD CONSTRAINT comentario_pkey1 PRIMARY KEY (id);
 K   ALTER TABLE ONLY "Gestion".tb_comentario DROP CONSTRAINT comentario_pkey1;
       Gestion         admin_proyecta_peru    false    197    197            9           2606    16818 "   tb_proyecto_ley proyecto_ley_pkey1 
   CONSTRAINT     c   ALTER TABLE ONLY "Gestion".tb_proyecto_ley
    ADD CONSTRAINT proyecto_ley_pkey1 PRIMARY KEY (id);
 O   ALTER TABLE ONLY "Gestion".tb_proyecto_ley DROP CONSTRAINT proyecto_ley_pkey1;
       Gestion         admin_proyecta_peru    false    195    195            A           2606    23859    tb_seccion seccion_pkey1 
   CONSTRAINT     Y   ALTER TABLE ONLY "Gestion".tb_seccion
    ADD CONSTRAINT seccion_pkey1 PRIMARY KEY (id);
 E   ALTER TABLE ONLY "Gestion".tb_seccion DROP CONSTRAINT seccion_pkey1;
       Gestion         admin_proyecta_peru    false    207    207            =           2606    16872     tb_seguimiento seguimiento_pkey1 
   CONSTRAINT     a   ALTER TABLE ONLY "Gestion".tb_seguimiento
    ADD CONSTRAINT seguimiento_pkey1 PRIMARY KEY (id);
 M   ALTER TABLE ONLY "Gestion".tb_seguimiento DROP CONSTRAINT seguimiento_pkey1;
       Gestion         admin_proyecta_peru    false    199    199            ?           2606    16893 :   tb_seguimiento_proyecto_ley seguimiento_proyecto_ley_pkey1 
   CONSTRAINT     �   ALTER TABLE ONLY "Gestion".tb_seguimiento_proyecto_ley
    ADD CONSTRAINT seguimiento_proyecto_ley_pkey1 PRIMARY KEY (id_seguimiento, id_proyecto_ley);
 g   ALTER TABLE ONLY "Gestion".tb_seguimiento_proyecto_ley DROP CONSTRAINT seguimiento_proyecto_ley_pkey1;
       Gestion         admin_proyecta_peru    false    200    200    200            3           2606    16754    tb_persona persona_pkey1 
   CONSTRAINT     \   ALTER TABLE ONLY "Seguridad".tb_persona
    ADD CONSTRAINT persona_pkey1 PRIMARY KEY (dni);
 G   ALTER TABLE ONLY "Seguridad".tb_persona DROP CONSTRAINT persona_pkey1;
    	   Seguridad         admin_proyecta_peru    false    189    189            1           2606    16746    tb_rol rol_pkey1 
   CONSTRAINT     S   ALTER TABLE ONLY "Seguridad".tb_rol
    ADD CONSTRAINT rol_pkey1 PRIMARY KEY (id);
 ?   ALTER TABLE ONLY "Seguridad".tb_rol DROP CONSTRAINT rol_pkey1;
    	   Seguridad         admin_proyecta_peru    false    188    188            5           2606    16774    tb_usuario usuario_pkey1 
   CONSTRAINT     [   ALTER TABLE ONLY "Seguridad".tb_usuario
    ADD CONSTRAINT usuario_pkey1 PRIMARY KEY (id);
 G   ALTER TABLE ONLY "Seguridad".tb_usuario DROP CONSTRAINT usuario_pkey1;
    	   Seguridad         admin_proyecta_peru    false    191    191            F           2606    16840 '   tb_comentario Ref_comentario_to_usuario    FK CONSTRAINT     �   ALTER TABLE ONLY "Gestion".tb_comentario
    ADD CONSTRAINT "Ref_comentario_to_usuario" FOREIGN KEY (id_usuario) REFERENCES "Seguridad".tb_usuario(id);
 V   ALTER TABLE ONLY "Gestion".tb_comentario DROP CONSTRAINT "Ref_comentario_to_usuario";
       Gestion       admin_proyecta_peru    false    2101    191    197            E           2606    16824 -   tb_proyecto_ley Ref_proyecto_ley_to_categoria    FK CONSTRAINT     �   ALTER TABLE ONLY "Gestion".tb_proyecto_ley
    ADD CONSTRAINT "Ref_proyecto_ley_to_categoria" FOREIGN KEY (id_categoria) REFERENCES "Gestion".tb_categoria(id);
 \   ALTER TABLE ONLY "Gestion".tb_proyecto_ley DROP CONSTRAINT "Ref_proyecto_ley_to_categoria";
       Gestion       admin_proyecta_peru    false    195    2103    193            D           2606    16819 +   tb_proyecto_ley Ref_proyecto_ley_to_usuario    FK CONSTRAINT     �   ALTER TABLE ONLY "Gestion".tb_proyecto_ley
    ADD CONSTRAINT "Ref_proyecto_ley_to_usuario" FOREIGN KEY (id_usuario) REFERENCES "Seguridad".tb_usuario(id);
 Z   ALTER TABLE ONLY "Gestion".tb_proyecto_ley DROP CONSTRAINT "Ref_proyecto_ley_to_usuario";
       Gestion       admin_proyecta_peru    false    195    2101    191            I           2606    23860 &   tb_seccion Ref_seccion_to_proyecto_ley    FK CONSTRAINT     �   ALTER TABLE ONLY "Gestion".tb_seccion
    ADD CONSTRAINT "Ref_seccion_to_proyecto_ley" FOREIGN KEY (id_proyecto_ley) REFERENCES "Gestion".tb_proyecto_ley(id);
 U   ALTER TABLE ONLY "Gestion".tb_seccion DROP CONSTRAINT "Ref_seccion_to_proyecto_ley";
       Gestion       admin_proyecta_peru    false    207    2105    195            H           2606    16899 H   tb_seguimiento_proyecto_ley Ref_seguimiento_proyecto_ley_to_proyecto_ley    FK CONSTRAINT     �   ALTER TABLE ONLY "Gestion".tb_seguimiento_proyecto_ley
    ADD CONSTRAINT "Ref_seguimiento_proyecto_ley_to_proyecto_ley" FOREIGN KEY (id_proyecto_ley) REFERENCES "Gestion".tb_proyecto_ley(id);
 w   ALTER TABLE ONLY "Gestion".tb_seguimiento_proyecto_ley DROP CONSTRAINT "Ref_seguimiento_proyecto_ley_to_proyecto_ley";
       Gestion       admin_proyecta_peru    false    2105    200    195            G           2606    16894 G   tb_seguimiento_proyecto_ley Ref_seguimiento_proyecto_ley_to_seguimiento    FK CONSTRAINT     �   ALTER TABLE ONLY "Gestion".tb_seguimiento_proyecto_ley
    ADD CONSTRAINT "Ref_seguimiento_proyecto_ley_to_seguimiento" FOREIGN KEY (id_seguimiento) REFERENCES "Gestion".tb_seguimiento(id);
 v   ALTER TABLE ONLY "Gestion".tb_seguimiento_proyecto_ley DROP CONSTRAINT "Ref_seguimiento_proyecto_ley_to_seguimiento";
       Gestion       admin_proyecta_peru    false    199    200    2109            B           2606    16775 !   tb_usuario Ref_usuario_to_persona    FK CONSTRAINT     �   ALTER TABLE ONLY "Seguridad".tb_usuario
    ADD CONSTRAINT "Ref_usuario_to_persona" FOREIGN KEY (dni_persona) REFERENCES "Seguridad".tb_persona(dni);
 R   ALTER TABLE ONLY "Seguridad".tb_usuario DROP CONSTRAINT "Ref_usuario_to_persona";
    	   Seguridad       admin_proyecta_peru    false    191    189    2099            C           2606    16780    tb_usuario Ref_usuario_to_rol    FK CONSTRAINT     �   ALTER TABLE ONLY "Seguridad".tb_usuario
    ADD CONSTRAINT "Ref_usuario_to_rol" FOREIGN KEY (id_rol) REFERENCES "Seguridad".tb_rol(id);
 N   ALTER TABLE ONLY "Seguridad".tb_usuario DROP CONSTRAINT "Ref_usuario_to_rol";
    	   Seguridad       admin_proyecta_peru    false    191    2097    188            �   A   x�3�tO�K-J��420��50�50U04�20�20�302403���L-J-I�ͯ�q�b���� �vD      �      x������ � �      �   g   x�3���T(ʯLM.�WHIU�I��t-.IUH-VH�Q(�,)�K��e�a(720��50�50U04�26"=#sCSs�?�ԢԒ����|��b���� .�"�      �   l   x�3��O�J-�WHIU�IT�I��t-.IUH-VH�Q����420��50�50U04�26"=#sCSs�?�ԢԒ����|ǐӄˌӭ4/%175�X��H�'F��� ��8_      �      x������ � �      �      x������ � �      �   �   x��ͱ
�0���+�	yy&1N�
J��%� c�ơ~}-];t����X+��N�5�	�P|�{���%�R��c�q��@)@�Gű%�qI�	�Fۆ� ]�o�o�z��>*���5������-�p�J�z����\Ct��ZI�'���R:�      �   }   x�e�1�0��+��X��9��!z��i,9��$R �7�r5;�ֵm��<J�[;}Ʋb�<�0�l�*�1������B4FEp^8đJ�M����N0L�v�R˶�zE�xq2
���O��1���)      �   �   x�m�Ao�0��s�+v�jm�YJ9�,�*�%^t0��*��{]<-���އ�ei�{�������"��<F����&6=i2#��^UQ��.؟d�o���$�b�)�����f��_�L�(���ĂP� �h��W���V�7��
J�@st��G��&����XE�����i�쾧�ۨ�)��l�I>�ʺ��3*�Q�m�!�q_���_-YL�     