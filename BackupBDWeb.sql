PGDMP  &                 
    |            Agencia_Seguros    16.2    16.4 �    7           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            8           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            9           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            :           1262    17755    Agencia_Seguros    DATABASE     �   CREATE DATABASE "Agencia_Seguros" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
 !   DROP DATABASE "Agencia_Seguros";
                postgres    false                       1255    17985    obtener_agencia_dadoid(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_agencia_dadoid(p_id_agencia_seguro integer) RETURNS TABLE(id_agencia_seguro integer, nombre_agencia_seguro character varying, direccion_postal character varying, telefono character varying, correo_electronico character varying, nombre_director_general character varying, nombre_jefe_departamento_seguros character varying, nombre_jefe_departamento_reclamaciones character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbAgenciaSeguro".id_agencia_seguro , public."tbAgenciaSeguro".nombre_agencia_seguro ,
	       public."tbAgenciaSeguro".direccion_postal , public."tbAgenciaSeguro".telefono , 
	       public."tbAgenciaSeguro".correo_electronico , public."tbAgenciaSeguro".nombre_director_general , 
		   public."tbAgenciaSeguro".nombre_jefe_departamento_seguros , public."tbAgenciaSeguro".nombre_jefe_departamento_reclamaciones
	FROM public."tbAgenciaSeguro"
    WHERE public."tbAgenciaSeguro".id_agencia_seguro = p_id_agencia_seguro;
END;
$$;
 J   DROP FUNCTION public.obtener_agencia_dadoid(p_id_agencia_seguro integer);
       public          postgres    false                       1255    18985    obtener_cliente_dadoid(integer)    FUNCTION     y  CREATE FUNCTION public.obtener_cliente_dadoid(p_numero_identidad_cliente integer) RETURNS TABLE(nombre_cliente character varying, numero_identidad_cliente integer, telefono character varying, direccion_postal character varying, correo_electronico character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbCliente".nombre_cliente, public."tbCliente".numero_identidad_cliente,
			public."tbCliente".telefono, public."tbCliente".direccion_postal, 
			public."tbCliente".correo_electronico
	 FROM public."tbCliente"
	 WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
END;
$$;
 Q   DROP FUNCTION public.obtener_cliente_dadoid(p_numero_identidad_cliente integer);
       public          postgres    false                       1255    17986    obtener_compre_dadoid(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_compre_dadoid(p_id_areaseguradora integer) RETURNS TABLE(nombre_compannia_reaseguradora character varying, nombre_pais character varying, nombre_tipo_reaseguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT 
		public."tbCompReaseguradora".nombre_compannia_reaseguradora, 
		public."tbPais".nombre_pais, public."tbTipoReaseguro".nombre_tipo_reaseguro
	FROM 
		public."tbCompReaseguradora", public."tbPais", public."tbTipoReaseguro"
	WHERE 
		public."tbCompReaseguradora".id_pais = public."tbPais".id_pais AND 
		public."tbCompReaseguradora".id_tipo_reaseguro = public."tbTipoReaseguro".id_tipo_reaseguro AND
		public."tbCompReaseguradora".id_comp_reaseguradora = p_id_aReaseguradora;
END;
$$;
 I   DROP FUNCTION public.obtener_compre_dadoid(p_id_areaseguradora integer);
       public          postgres    false            T           1255    19353 A   obtener_ingresos_mensuales_por_concepto_primas_dado_anno(integer)    FUNCTION     J  CREATE FUNCTION public.obtener_ingresos_mensuales_por_concepto_primas_dado_anno(p_anno integer) RETURNS TABLE(anno integer, mes integer, monto_pagado double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT public."tbPrimaMensual".anno, 
	       public."tbPrimaMensual".mes,
           SUM(public."tbPrimaMensual".monto_pagado)
    FROM public."tbPrimaMensual"
    WHERE public."tbPrimaMensual".anno= p_anno
	GROUP BY 
	public."tbPrimaMensual".anno,
	public."tbPrimaMensual".mes
	ORDER BY 
	public."tbPrimaMensual".mes,
	public."tbPrimaMensual".anno;
END;
$$;
 _   DROP FUNCTION public.obtener_ingresos_mensuales_por_concepto_primas_dado_anno(p_anno integer);
       public          postgres    false            [           1255    18984 5   obtener_polizas_activas_cantidad_dadocliente(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_polizas_activas_cantidad_dadocliente(p_numero_identidad_cliente integer) RETURNS TABLE(numero_poliza integer, contador integer)
    LANGUAGE plpgsql
    AS $$
DECLARE contador INTEGER;
BEGIN
	SELECT COUNT(*) INTO contador
	FROM public."tbPoliza"
	WHERE public."tbPoliza".id_estado_poliza = 3 AND 
		  public."tbPoliza".numero_identidad_cliente = p_numero_identidad_cliente;
	    RETURN QUERY
	    SELECT public."tbPoliza".numero_poliza, contador 
	    FROM public."tbPoliza"
	    WHERE public."tbPoliza".id_estado_poliza = 3 AND 
			  public."tbPoliza".numero_identidad_cliente = p_numero_identidad_cliente;
END;
$$;
 g   DROP FUNCTION public.obtener_polizas_activas_cantidad_dadocliente(p_numero_identidad_cliente integer);
       public          postgres    false            >           1255    18995 8   obtener_polizas_emitidas_dado_periodo_tiempo(date, date)    FUNCTION     G  CREATE FUNCTION public.obtener_polizas_emitidas_dado_periodo_tiempo(p_fecha_inicio date, p_fecha_fin date) RETURNS TABLE(numero_poliza integer, nombre_cliente character varying, nombre_tipo_seguro character varying, fecha_incio date, fecha_fin date, prima_mensual double precision, nombre_estado_poliza character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbPoliza".numero_poliza, public."tbCliente".nombre_cliente,
		   public."tbTipoSeguro".nombre_tipo_seguro, public."tbPoliza".fecha_inicio, 
		   public."tbPoliza".fecha_fin,
		   public."tbPoliza".prima_mensual, public."tbEstadoPoliza".nombre_estado_poliza
		   
	FROM public."tbPoliza" , public."tbTipoSeguro", public."tbEstadoPoliza", public."tbCliente"
	WHERE public."tbPoliza".numero_identidad_cliente = public."tbCliente".numero_identidad_cliente AND
		  public."tbPoliza".id_tipo_seguro = public."tbTipoSeguro".id_tipo_seguro AND
		  public."tbPoliza".id_estado_poliza = public."tbEstadoPoliza".id_estado_poliza AND
		  public."tbPoliza".fecha_inicio BETWEEN p_fecha_inicio AND p_fecha_fin;
END;
$$;
 j   DROP FUNCTION public.obtener_polizas_emitidas_dado_periodo_tiempo(p_fecha_inicio date, p_fecha_fin date);
       public          postgres    false                       1255    17988 =   obtener_pparticipacion_dado_idagen_idcompre(integer, integer)    FUNCTION     �  CREATE FUNCTION public.obtener_pparticipacion_dado_idagen_idcompre(p_id_comp_reaseguradora integer, p_id_agencia integer) RETURNS TABLE(nombre_tipo_seguro character varying, porciento_participacion double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT 
		public."tbTipoSeguro".nombre_tipo_seguro, public."tbPorcentParticipacion".porciento_participacion
	FROM 
		public."tbPorcentParticipacion", public."tbTipoSeguro"
	WHERE 
		public."tbPorcentParticipacion".id_tipo_seguro = public."tbTipoSeguro".id_tipo_seguro AND
		public."tbPorcentParticipacion".id_comp_reaseguradora = p_id_comp_reaseguradora AND
		public."tbPorcentParticipacion".id_agencia_seguro = p_id_agencia
	ORDER BY porciento_participacion ASC; 
END;
$$;
 y   DROP FUNCTION public.obtener_pparticipacion_dado_idagen_idcompre(p_id_comp_reaseguradora integer, p_id_agencia integer);
       public          postgres    false            &           1255    18990 ,   obtener_reclamaciones_dado_polizaid(integer)    FUNCTION       CREATE FUNCTION public.obtener_reclamaciones_dado_polizaid(p_numero_poliza integer) RETURNS TABLE(numero_reclamacion integer, numero_poliza integer, id_estado_reclamacion integer, id_tipo_siniestro integer, fecha_siniestro date, monto_reclamado double precision, monto_indemnizado double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbReclamacion".numero_reclamacion, public."tbReclamacion".numero_poliza, 
		   public."tbReclamacion".id_estado_reclamacion, public."tbReclamacion".id_tipo_siniestro, 
		   public."tbReclamacion".fecha_siniestro , public."tbReclamacion".monto_reclamado, 
		   public."tbReclamacion".monto_indemnizado 
	FROM public."tbReclamacion" 
	WHERE public."tbReclamacion".numero_poliza = p_numero_poliza;
END;
$$;
 S   DROP FUNCTION public.obtener_reclamaciones_dado_polizaid(p_numero_poliza integer);
       public          postgres    false            \           1255    18988 /   obtener_valor_total_primas_dado_poliza(integer)    FUNCTION     ]  CREATE FUNCTION public.obtener_valor_total_primas_dado_poliza(p_numero_poliza integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE resultado DOUBLE PRECISION;
BEGIN
	SELECT SUM(monto_pagado) INTO resultado
	FROM public."tbPrimaMensual" 
	WHERE public."tbPrimaMensual".numero_poliza = p_numero_poliza;
	RETURN resultado;
END;
$$;
 V   DROP FUNCTION public.obtener_valor_total_primas_dado_poliza(p_numero_poliza integer);
       public          postgres    false                       1255    19435 *   roger_obtener_poliza_dado_cliente(integer)    FUNCTION     =  CREATE FUNCTION public.roger_obtener_poliza_dado_cliente(p_id_cliente integer) RETURNS TABLE(numero_poliza integer, nombre_agencia_seguro character varying, nombre_estado_poliza character varying, nombre_tipo_seguro character varying, fecha_inicio date, fecha_fin date, prima_mensual double precision, monto_total_asegurado double precision, nombre_tipo_cobertura character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY
SELECT public."tbPoliza".numero_poliza , public."tbAgenciaSeguro".nombre_agencia_seguro , 
		public."tbEstadoPoliza".nombre_estado_poliza, public."tbTipoSeguro".nombre_tipo_seguro , 
		public."tbPoliza".fecha_inicio , public."tbPoliza".fecha_fin , public."tbPoliza".prima_mensual , 
		public."tbPoliza".monto_total_asegurado , public."tbTipoCobertura".nombre_tipo_cobertura
FROM public."tbPoliza", public."tbEstadoPoliza", public."tbAgenciaSeguro", public."tbTipoCobertura", public."tbTipoSeguro"
WHERE public."tbPoliza".id_tipo_cobertura= public."tbTipoCobertura".id_tipo_cobertura AND
	  public."tbPoliza".id_agencia_seguro= public."tbAgenciaSeguro".id_agencia_seguro AND
	  public."tbPoliza".id_tipo_seguro =public."tbTipoSeguro".id_tipo_seguro AND
	  public."tbPoliza".id_estado_poliza = public."tbEstadoPoliza".id_estado_poliza AND
	  public."tbPoliza".numero_identidad_cliente = p_id_cliente;
END;
$$;
 N   DROP FUNCTION public.roger_obtener_poliza_dado_cliente(p_id_cliente integer);
       public          postgres    false            U           1255    19388 *   salida_motivo_rechazo_reclamacion(integer)    FUNCTION     Y  CREATE FUNCTION public.salida_motivo_rechazo_reclamacion(p_numero_identidad_cliente integer) RETURNS TABLE(motivo_rechazo text)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT  public."tbMotivoRechazoReclamacion".motivo_rechazo
	FROM public."tbMotivoRechazoReclamacion", public."tbPoliza", public."tbReclamacion"
	WHERE public."tbPoliza".numero_poliza = public."tbReclamacion".numero_poliza AND 
		  public."tbMotivoRechazoReclamacion".numero_reclamacion = public."tbReclamacion".numero_reclamacion  AND
		  public."tbPoliza".numero_identidad_cliente = p_numero_identidad_cliente;
END;
$$;
 \   DROP FUNCTION public.salida_motivo_rechazo_reclamacion(p_numero_identidad_cliente integer);
       public          postgres    false            /           1255    19415 .   salida_obtener_poliza_dado_tiposeguro(integer)    FUNCTION     B  CREATE FUNCTION public.salida_obtener_poliza_dado_tiposeguro(p_id_tipo_seguro integer) RETURNS TABLE(numero_poliza integer, numero_identidad_cliente integer, fecha_inicio date, fecha_fin date, prima_mensual double precision, monto_total_asegurado double precision, nombre_estado_poliza character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbPoliza".numero_poliza, public."tbPoliza".numero_identidad_cliente,
		   public."tbPoliza".fecha_inicio, public."tbPoliza".fecha_fin, public."tbPoliza".prima_mensual,
		   public."tbPoliza".monto_total_asegurado, public."tbEstadoPoliza".nombre_estado_poliza
	FROM public."tbPoliza", public."tbEstadoPoliza"
	WHERE public."tbPoliza".id_tipo_seguro = p_id_tipo_seguro AND
			public."tbPoliza".id_estado_poliza = public."tbEstadoPoliza".id_estado_poliza;
END;
$$;
 V   DROP FUNCTION public.salida_obtener_poliza_dado_tiposeguro(p_id_tipo_seguro integer);
       public          postgres    false            $           1255    19401 '   salida_polizas_activas_cliente(integer)    FUNCTION     �  CREATE FUNCTION public.salida_polizas_activas_cliente(p_id_pais integer) RETURNS TABLE(nombre_cliente character varying, numero_identidad_cliente integer, id_estado_poliza bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY
SELECT public."tbCliente".nombre_cliente,
	   public."tbCliente".numero_identidad_cliente,
	   COUNT (public."tbPoliza".id_estado_poliza)
FROM  public."tbCliente", public."tbPoliza"
WHERE 
	public."tbCliente".numero_identidad_cliente = public."tbPoliza".numero_identidad_cliente AND
	public."tbPoliza".id_estado_poliza = 3 AND
	public."tbCliente".id_pais = p_id_pais
GROUP BY public."tbCliente".numero_identidad_cliente;
END;
$$;
 H   DROP FUNCTION public.salida_polizas_activas_cliente(p_id_pais integer);
       public          postgres    false                       1255    19421 9   salida_porciento_participacion_dado_id_compannia(integer)    FUNCTION     �  CREATE FUNCTION public.salida_porciento_participacion_dado_id_compannia(p_id_comp_reaseguradora integer) RETURNS TABLE(nombre_tipo_seguro character varying, porciento_participacion double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	RETURN QUERY
	SELECT public."tbTipoSeguro".nombre_tipo_seguro, 
		   public."tbPorcentParticipacion".porciento_participacion
	FROM public."tbPorcentParticipacion", public."tbTipoSeguro"
	WHERE public."tbPorcentParticipacion".id_tipo_seguro = public."tbTipoSeguro".id_tipo_seguro AND
		  public."tbPorcentParticipacion".id_comp_reaseguradora = p_id_comp_reaseguradora
	ORDER BY public."tbPorcentParticipacion".porciento_participacion ASC;
END;
$$;
 h   DROP FUNCTION public.salida_porciento_participacion_dado_id_compannia(p_id_comp_reaseguradora integer);
       public          postgres    false            Y           1255    19404 *   salida_total_monto_pagado_cliente(integer)    FUNCTION       CREATE FUNCTION public.salida_total_monto_pagado_cliente(p_id_pais integer) RETURNS TABLE(nombre_cliente character varying, numero_identidad_cliente integer, monto_pagado double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY
SELECT public."tbCliente".nombre_cliente,
	   public."tbCliente".numero_identidad_cliente,
	   SUM(public."tbPrimaMensual".monto_pagado)
FROM  public."tbCliente", public."tbPoliza", public."tbPrimaMensual"
WHERE 
	public."tbCliente".numero_identidad_cliente = public."tbPoliza".numero_identidad_cliente AND
	public."tbPoliza".id_estado_poliza = 3 AND
	public."tbPrimaMensual".numero_poliza = public."tbPoliza".numero_poliza AND
	public."tbCliente".id_pais = p_id_pais
GROUP BY public."tbCliente".numero_identidad_cliente;
END;
$$;
 K   DROP FUNCTION public.salida_total_monto_pagado_cliente(p_id_pais integer);
       public          postgres    false            O           1255    18141    tbagenciaseguro_delete(integer)    FUNCTION     I  CREATE FUNCTION public.tbagenciaseguro_delete(p_id_agencia_seguro integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
		resultado:=true;
		BEGIN
		DELETE FROM public."tbAgenciaSeguro" 
		WHERE public."tbAgenciaSeguro".id_agencia_seguro = p_id_agencia_seguro;
		END;
		RETURN resultado;
END;
$$;
 J   DROP FUNCTION public.tbagenciaseguro_delete(p_id_agencia_seguro integer);
       public          postgres    false            L           1255    18137 �   tbagenciaseguro_insert(character varying, character varying, character varying, character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.tbagenciaseguro_insert(p_nombre_agencia_seguro character varying, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_nombre_director_general character varying, p_nombre_jefe_departamento_seguros character varying, p_nombre_jefe_departamento_reclamaciones character varying) RETURNS TABLE(id_agencia_seguro integer, nombre_agencia_seguro character varying, direccion_postal character varying, telefono character varying, correo_electronico character varying, nombre_director_general character varying, nombre_jefe_departamento_seguros character varying, nombre_jefe_departamento_reclamaciones character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN
		INSERT INTO public."tbAgenciaSeguro" (nombre_agencia_seguro,
											  direccion_postal, telefono, 
											  correo_electronico,nombre_director_general,
											  nombre_jefe_departamento_seguros, 
											  nombre_jefe_departamento_reclamaciones) 
		VALUES 
		(p_nombre_agencia_seguro, p_direccion_postal, 
		 p_telefono, p_correo_electronico, 
		 p_nombre_director_general, p_nombre_jefe_departamento_seguros, 
		 p_nombre_jefe_departamento_reclamaciones);
		RETURN QUERY
		SELECT public."tbAgenciaSeguro".id_agencia_seguro, public."tbAgenciaSeguro".nombre_agencia_seguro ,public."tbAgenciaSeguro".direccion_postal , public."tbAgenciaSeguro".telefono , 
			   public."tbAgenciaSeguro".correo_electronico ,public."tbAgenciaSeguro".nombre_director_general ,
			   public."tbAgenciaSeguro".nombre_jefe_departamento_seguros , 
			   public."tbAgenciaSeguro".nombre_jefe_departamento_reclamaciones 
		FROM public."tbAgenciaSeguro" 
		WHERE public."tbAgenciaSeguro".correo_electronico=p_correo_electronico;
END;
$$;
 c  DROP FUNCTION public.tbagenciaseguro_insert(p_nombre_agencia_seguro character varying, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_nombre_director_general character varying, p_nombre_jefe_departamento_seguros character varying, p_nombre_jefe_departamento_reclamaciones character varying);
       public          postgres    false            F           1255    18138    tbagenciaseguro_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbagenciaseguro_read(p_id_agencia_seguro integer) RETURNS TABLE(id_agencia_seguro integer, nombre_agencia_seguro character varying, direccion_postal character varying, telefono character varying, correo_electronico character varying, nombre_director_general character varying, nombre_jefe_departamento_seguros character varying, nombre_jefe_departamento_reclamaciones character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN
		RETURN QUERY
		SELECT public."tbAgenciaSeguro".id_agencia_seguro, public."tbAgenciaSeguro".nombre_agencia_seguro ,public."tbAgenciaSeguro".direccion_postal , public."tbAgenciaSeguro".telefono , 
			   public."tbAgenciaSeguro".correo_electronico ,public."tbAgenciaSeguro".nombre_director_general ,
			   public."tbAgenciaSeguro".nombre_jefe_departamento_seguros , 
			   public."tbAgenciaSeguro".nombre_jefe_departamento_reclamaciones 
		FROM public."tbAgenciaSeguro" 
		WHERE public."tbAgenciaSeguro".id_agencia_seguro=p_id_agencia_seguro;
END;
$$;
 H   DROP FUNCTION public.tbagenciaseguro_read(p_id_agencia_seguro integer);
       public          postgres    false            #           1255    18139 �   tbagenciaseguro_update(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.tbagenciaseguro_update(p_id_agencia_seguro integer, p_nombre_agencia_seguro character varying, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_nombre_director_general character varying, p_nombre_jefe_departamento_seguros character varying, p_nombre_jefe_departamento_reclamaciones character varying) RETURNS TABLE(id_agencia_seguro integer, nombre_agencia_seguro character varying, direccion_postal character varying, telefono character varying, correo_electronico character varying, nombre_director_general character varying, nombre_jefe_departamento_seguros character varying, nombre_jefe_departamento_reclamaciones character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		UPDATE public."tbAgenciaSeguro" 
		SET 
		nombre_agencia_seguro=p_nombre_agencia_seguro, direccion_postal=p_direccion_postal, 
		telefono=p_telefono, correo_electronico=p_correo_electronico, 
		nombre_director_general=p_nombre_director_general, nombre_jefe_departamento_seguros=p_nombre_jefe_departamento_seguros, 
		nombre_jefe_departamento_reclamaciones=p_nombre_jefe_departamento_reclamaciones
		WHERE public."tbAgenciaSeguro".id_agencia_seguro= p_id_agencia_seguro;
		RETURN QUERY
		SELECT public."tbAgenciaSeguro".id_agencia_seguro, public."tbAgenciaSeguro".nombre_agencia_seguro ,public."tbAgenciaSeguro".direccion_postal , public."tbAgenciaSeguro".telefono , 
			   public."tbAgenciaSeguro".correo_electronico ,public."tbAgenciaSeguro".nombre_director_general ,
			   public."tbAgenciaSeguro".nombre_jefe_departamento_seguros , 
			   public."tbAgenciaSeguro".nombre_jefe_departamento_reclamaciones 
		FROM public."tbAgenciaSeguro" 
		WHERE public."tbAgenciaSeguro".id_agencia_seguro=p_id_agencia_seguro;
END;
$$;
 �  DROP FUNCTION public.tbagenciaseguro_update(p_id_agencia_seguro integer, p_nombre_agencia_seguro character varying, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_nombre_director_general character varying, p_nombre_jefe_departamento_seguros character varying, p_nombre_jefe_departamento_reclamaciones character varying);
       public          postgres    false            9           1255    18017    tbcliente_delete(integer)    FUNCTION     O  CREATE FUNCTION public.tbcliente_delete(p_numero_identidad_cliente integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
		resultado:= true;
		BEGIN
			DELETE FROM public."tbCliente" 
			WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
		END;
		RETURN resultado;
END;
$$;
 K   DROP FUNCTION public.tbcliente_delete(p_numero_identidad_cliente integer);
       public          postgres    false            <           1255    18010 �   tbcliente_insert(integer, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying)    FUNCTION     A  CREATE FUNCTION public.tbcliente_insert(p_id_pais integer, p_id_sexo integer, p_nombre_cliente character varying, p_apellido_cliente character varying, p_edad integer, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_carnet_identidad character varying) RETURNS TABLE(numero_id_cliente integer, id_pais integer, id_sexo integer, nombre_cliente character varying, apellido_cliente character varying, edad integer, direccion_postal character varying, telefono character varying, correo_electronico character varying, carnet_identidad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbCliente" (id_pais, id_sexo , 
			  nombre_cliente , apellido_cliente , edad , direccion_postal , telefono, 
			  correo_electronico , carnet_identidad) VALUES (p_id_pais, p_id_sexo , 
											p_nombre_cliente, p_apellido_cliente ,
										   p_edad , p_direccion_postal , 
											p_telefono , p_correo_electronico,
											p_carnet_identidad);
		RETURN QUERY
		SELECT *
		FROM public."tbCliente";
END;
$$;
 9  DROP FUNCTION public.tbcliente_insert(p_id_pais integer, p_id_sexo integer, p_nombre_cliente character varying, p_apellido_cliente character varying, p_edad integer, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_carnet_identidad character varying);
       public          postgres    false            2           1255    18015    tbcliente_read(integer)    FUNCTION     .  CREATE FUNCTION public.tbcliente_read(p_numero_identidad_cliente integer) RETURNS TABLE(numero_identidad_cliente integer, id_pais integer, id_sexo integer, nombre_cliente character varying, apellido_cliente character varying, edad integer, direccion_postal character varying, telefono character varying, correo_electronico character varying, carnet_identidad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		RETURN QUERY
		SELECT *
		FROM public."tbCliente"
		WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
END;
$$;
 I   DROP FUNCTION public.tbcliente_read(p_numero_identidad_cliente integer);
       public          postgres    false                       1255    18016 �   tbcliente_update(integer, integer, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.tbcliente_update(p_numero_identidad_cliente integer, p_id_pais integer, p_id_sexo integer, p_nombre_cliente character varying, p_apellido_cliente character varying, p_edad integer, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_carnet_identidad character varying) RETURNS TABLE(numero_identidad_cliente integer, id_pais integer, id_sexo integer, nombre_cliente character varying, apellido_cliente character varying, edad integer, direccion_postal character varying, telefono character varying, correo_electronico character varying, carnet_identidad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		UPDATE public."tbCliente" 
		SET id_pais= p_id_pais , id_sexo= p_id_sexo, nombre_cliente= p_nombre_cliente, apellido_cliente= p_apellido_cliente, edad= p_edad, direccion_postal= p_direccion_postal, telefono= p_telefono , correo_electronico= p_correo_electronico, carnet_identidad= p_carnet_identidad
		WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
		RETURN QUERY
		SELECT *
		FROM public."tbCliente"
		WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
END;
$$;
 ]  DROP FUNCTION public.tbcliente_update(p_numero_identidad_cliente integer, p_id_pais integer, p_id_sexo integer, p_nombre_cliente character varying, p_apellido_cliente character varying, p_edad integer, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_carnet_identidad character varying);
       public          postgres    false                       1255    18157 #   tbcompreaseguradora_delete(integer)    FUNCTION     c  CREATE FUNCTION public.tbcompreaseguradora_delete(p_id_comp_reaseguradora integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
		resultado:= true;
		BEGIN
		DELETE FROM public."tbCompReaseguradora" 
		WHERE public."tbCompReaseguradora".id_comp_reaseguradora = p_id_comp_reaseguradora; 
		END;
		RETURN resultado;
END;
$$;
 R   DROP FUNCTION public.tbcompreaseguradora_delete(p_id_comp_reaseguradora integer);
       public          postgres    false            ;           1255    18147 ?   tbcompreaseguradora_insert(integer, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbcompreaseguradora_insert(p_id_pais integer, p_id_tipo_reaseguro integer, p_nombre_compannia_reaseguradora character varying) RETURNS TABLE(id_comp_reaseguradora integer, id_pais integer, id_tipo_reaseguro integer, nombre_compannia_reaseguradora character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		INSERT INTO public."tbCompReaseguradora" (id_pais , id_tipo_reaseguro , nombre_compannia_reaseguradora) 
		VALUES (p_id_pais , p_id_tipo_reaseguro, p_nombre_compannia_reaseguradora);
		RETURN QUERY
		SELECT public."tbCompReaseguradora".id_comp_reaseguradora,
			   public."tbCompReaseguradora".id_pais , 
			   public."tbCompReaseguradora".id_tipo_reaseguro , 
			   public."tbCompReaseguradora".nombre_compannia_reaseguradora
		FROM public."tbCompReaseguradora" 
		WHERE public."tbCompReaseguradora".nombre_compannia_reaseguradora = p_nombre_compannia_reaseguradora ;
END;
$$;
 �   DROP FUNCTION public.tbcompreaseguradora_insert(p_id_pais integer, p_id_tipo_reaseguro integer, p_nombre_compannia_reaseguradora character varying);
       public          postgres    false            +           1255    18150 !   tbcompreaseguradora_read(integer)    FUNCTION     z  CREATE FUNCTION public.tbcompreaseguradora_read(p_id_comp_reaseguradora integer) RETURNS TABLE(id_comp_reaseguradora integer, id_pais integer, id_tipo_reaseguro integer, nombre_compannia_reaseguradora character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		RETURN QUERY
		SELECT public."tbCompReaseguradora".id_comp_reaseguradora,
			   public."tbCompReaseguradora".id_pais , 
			   public."tbCompReaseguradora".id_tipo_reaseguro , 
			   public."tbCompReaseguradora".nombre_compannia_reaseguradora
		FROM public."tbCompReaseguradora" 
		WHERE public."tbCompReaseguradora".id_comp_reaseguradora = p_id_comp_reaseguradora ;
END;
$$;
 P   DROP FUNCTION public.tbcompreaseguradora_read(p_id_comp_reaseguradora integer);
       public          postgres    false                       1255    18149 H   tbcompreaseguradora_update(integer, integer, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbcompreaseguradora_update(p_id_comp_reaseguradora integer, p_id_pais integer, p_id_tipo_reaseguro integer, p_nombre_compannia_reaseguradora character varying) RETURNS TABLE(id_comp_reaseguradora integer, id_pais integer, id_tipo_reaseguro integer, nombre_compannia_reaseguradora character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		UPDATE public."tbCompReaseguradora" 
		SET id_pais=p_id_pais , id_tipo_reaseguro=p_id_tipo_reaseguro , nombre_compannia_reaseguradora=p_nombre_compannia_reaseguradora
		WHERE public."tbCompReaseguradora".id_comp_reaseguradora=p_id_comp_reaseguradora;
		RETURN QUERY
		SELECT public."tbCompReaseguradora".id_comp_reaseguradora,
			   public."tbCompReaseguradora".id_pais , 
			   public."tbCompReaseguradora".id_tipo_reaseguro , 
			   public."tbCompReaseguradora".nombre_compannia_reaseguradora
		FROM public."tbCompReaseguradora" 
		WHERE public."tbCompReaseguradora".nombre_compannia_reaseguradora = p_nombre_compannia_reaseguradora ;
END;
$$;
 �   DROP FUNCTION public.tbcompreaseguradora_update(p_id_comp_reaseguradora integer, p_id_pais integer, p_id_tipo_reaseguro integer, p_nombre_compannia_reaseguradora character varying);
       public          postgres    false            0           1255    18317    tbestadopoliza_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbestadopoliza_read(p_id_estado_poliza integer) RETURNS TABLE(id_estado_poliza integer, nombre_estado_poliza character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
		SELECT public."tbEstadoPoliza".id_estado_poliza, public."tbEstadoPoliza".nombre_estado_poliza  
		FROM public."tbEstadoPoliza"
		WHERE public."tbEstadoPoliza".id_estado_poliza = p_id_estado_poliza;
	END;
	$$;
 F   DROP FUNCTION public.tbestadopoliza_read(p_id_estado_poliza integer);
       public          postgres    false            I           1255    18318 !   tbestadoreclamacion_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbestadoreclamacion_read(p_id_estado_reclamacion integer) RETURNS TABLE(id_estado_reclamacion integer, nombre_estado_reclamacion character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
		SELECT public."tbEstadoReclamacion".id_estado_reclamacion, public."tbEstadoReclamacion".nombre_estado_reclamacion  
		FROM public."tbEstadoReclamacion"
		WHERE public."tbEstadoReclamacion".id_estado_reclamacion = p_id_estado_reclamacion;
	END;
	$$;
 P   DROP FUNCTION public.tbestadoreclamacion_read(p_id_estado_reclamacion integer);
       public          postgres    false            E           1255    18205 )   tbmotivocancelacionpoliza_delete(integer)    FUNCTION     ^  CREATE FUNCTION public.tbmotivocancelacionpoliza_delete(p_numero_poliza integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado BOOL;
BEGIN
		resultado:= true;
		BEGIN
		DELETE FROM public."tbMotivoCancelacionPoliza" 
		WHERE public."tbMotivoCancelacionPoliza".numero_poliza = p_numero_poliza;
		END;
		RETURN resultado;
		END;
$$;
 P   DROP FUNCTION public.tbmotivocancelacionpoliza_delete(p_numero_poliza integer);
       public          postgres    false            X           1255    18199 /   tbmotivocancelacionpoliza_insert(integer, text)    FUNCTION     W  CREATE FUNCTION public.tbmotivocancelacionpoliza_insert(p_numero_poliza integer, p_descripcion_motivo text) RETURNS TABLE(numero_poliza integer, descripcion_motivo text)
    LANGUAGE plpgsql
    AS $$
BEGIN
		INSERT INTO public."tbMotivoCancelacionPoliza" (numero_poliza, descripcion_motivo) 
		VALUES (p_numero_poliza, p_descripcion_motivo);
		RETURN QUERY
		SELECT public."tbMotivoCancelacionPoliza".numero_poliza, 
		public."tbMotivoCancelacionPoliza".descripcion_motivo
		FROM public."tbMotivoCancelacionPoliza"
		WHERE public."tbMotivoCancelacionPoliza".numero_poliza=p_numero_poliza;
END;
$$;
 k   DROP FUNCTION public.tbmotivocancelacionpoliza_insert(p_numero_poliza integer, p_descripcion_motivo text);
       public          postgres    false                       1255    18204 '   tbmotivocancelacionpoliza_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbmotivocancelacionpoliza_read(p_numero_poliza integer) RETURNS TABLE(numero_poliza integer, descripcion_motivo text)
    LANGUAGE plpgsql
    AS $$
BEGIN
		RETURN QUERY
		SELECT public."tbMotivoCancelacionPoliza".numero_poliza, 
		public."tbMotivoCancelacionPoliza".descripcion_motivo
		FROM public."tbMotivoCancelacionPoliza"
		WHERE public."tbMotivoCancelacionPoliza".numero_poliza=p_numero_poliza;
END;
$$;
 N   DROP FUNCTION public.tbmotivocancelacionpoliza_read(p_numero_poliza integer);
       public          postgres    false            H           1255    18202 /   tbmotivocancelacionpoliza_update(integer, text)    FUNCTION     y  CREATE FUNCTION public.tbmotivocancelacionpoliza_update(p_numero_poliza integer, p_descripcion_motivo text) RETURNS TABLE(numero_poliza integer, descripcion_motivo text)
    LANGUAGE plpgsql
    AS $$
BEGIN
		UPDATE public."tbMotivoCancelacionPoliza" 
		SET descripcion_motivo = p_descripcion_motivo 
		WHERE public."tbMotivoCancelacionPoliza".numero_poliza = p_numero_poliza;
		RETURN QUERY
		SELECT public."tbMotivoCancelacionPoliza".numero_poliza, 
		public."tbMotivoCancelacionPoliza".descripcion_motivo
		FROM public."tbMotivoCancelacionPoliza"
		WHERE public."tbMotivoCancelacionPoliza".numero_poliza=p_numero_poliza;
END;
$$;
 k   DROP FUNCTION public.tbmotivocancelacionpoliza_update(p_numero_poliza integer, p_descripcion_motivo text);
       public          postgres    false            K           1255    18211 *   tbmotivorechazoreclamacion_delete(integer)    FUNCTION     q  CREATE FUNCTION public.tbmotivorechazoreclamacion_delete(p_numero_reclamacion integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado BOOL;
BEGIN
		resultado:=true;
			BEGIN
			DELETE FROM public."tbMotivoRechazoReclamacion" 
			WHERE public."tbMotivoRechazoReclamacion".numero_reclamacion = p_numero_reclamacion;
			END;
		RETURN resultado;
END;
$$;
 V   DROP FUNCTION public.tbmotivorechazoreclamacion_delete(p_numero_reclamacion integer);
       public          postgres    false            Z           1255    18207 0   tbmotivorechazoreclamacion_insert(integer, text)    FUNCTION     r  CREATE FUNCTION public.tbmotivorechazoreclamacion_insert(p_numero_reclamacion integer, p_motivo_rechazo text) RETURNS TABLE(numero_reclamacion integer, motivo_rechazo text)
    LANGUAGE plpgsql
    AS $$
BEGIN
		INSERT INTO public."tbMotivoRechazoReclamacion" (numero_reclamacion , motivo_rechazo )
		VALUES (p_numero_reclamacion , p_motivo_rechazo);
		RETURN QUERY
		SELECT public."tbMotivoRechazoReclamacion".numero_reclamacion, 
		public."tbMotivoRechazoReclamacion".motivo_rechazo
		FROM public."tbMotivoRechazoReclamacion"
		WHERE public."tbMotivoRechazoReclamacion".numero_reclamacion = p_numero_reclamacion;
		END;
$$;
 m   DROP FUNCTION public.tbmotivorechazoreclamacion_insert(p_numero_reclamacion integer, p_motivo_rechazo text);
       public          postgres    false            Q           1255    18209 (   tbmotivorechazoreclamacion_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbmotivorechazoreclamacion_read(p_numero_reclamacion integer) RETURNS TABLE(numero_reclamacion integer, motivo_rechazo text)
    LANGUAGE plpgsql
    AS $$
BEGIN
		RETURN QUERY
		SELECT public."tbMotivoRechazoReclamacion".numero_reclamacion, 
		public."tbMotivoRechazoReclamacion".motivo_rechazo
		FROM public."tbMotivoRechazoReclamacion"
		WHERE public."tbMotivoRechazoReclamacion".numero_reclamacion = p_numero_reclamacion;
		END;
$$;
 T   DROP FUNCTION public.tbmotivorechazoreclamacion_read(p_numero_reclamacion integer);
       public          postgres    false            4           1255    18208 0   tbmotivorechazoreclamacion_update(integer, text)    FUNCTION     �  CREATE FUNCTION public.tbmotivorechazoreclamacion_update(p_numero_reclamacion integer, p_motivo_rechazo text) RETURNS TABLE(numero_reclamacion integer, motivo_rechazo text)
    LANGUAGE plpgsql
    AS $$
BEGIN
		UPDATE public."tbMotivoRechazoReclamacion" SET motivo_rechazo=p_motivo_rechazo 
		WHERE public."tbMotivoRechazoReclamacion".numero_reclamacion = p_numero_reclamacion;
		RETURN QUERY
		SELECT public."tbMotivoRechazoReclamacion".numero_reclamacion, 
		public."tbMotivoRechazoReclamacion".motivo_rechazo
		FROM public."tbMotivoRechazoReclamacion"
		WHERE public."tbMotivoRechazoReclamacion".numero_reclamacion = p_numero_reclamacion;
		END;
$$;
 m   DROP FUNCTION public.tbmotivorechazoreclamacion_update(p_numero_reclamacion integer, p_motivo_rechazo text);
       public          postgres    false            C           1255    18006    tbpais_delete(integer)    FUNCTION     D  CREATE FUNCTION public.tbpais_delete(p_id_pais integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	resultado := true;
	BEGIN 
		DELETE FROM public."tbPais" WHERE public."tbPais".id_pais = p_id_pais;
		EXCEPTION WHEN NO_DATA_FOUND THEN resultado := false;
	END;
	RETURN resultado;
END;
$$;
 7   DROP FUNCTION public.tbpais_delete(p_id_pais integer);
       public          postgres    false                       1255    18003     tbpais_insert(character varying)    FUNCTION     �  CREATE FUNCTION public.tbpais_insert(p_nombre_pais character varying) RETURNS TABLE(id_pais integer, nombre_pais character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO public."tbPais" (nombre_pais) VALUES (p_nombre_pais);
    RETURN QUERY
	SELECT public."tbPais".id_pais, public."tbPais".nombre_pais
	FROM public."tbPais"
    WHERE public."tbPais".nombre_pais = p_nombre_pais;
END;
$$;
 E   DROP FUNCTION public.tbpais_insert(p_nombre_pais character varying);
       public          postgres    false            =           1255    18316    tbpais_read(integer)    FUNCTION     8  CREATE FUNCTION public.tbpais_read(p_id_pais integer) RETURNS TABLE(id_pais integer, nombre_pais character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
		SELECT public."tbPais".id_pais, public."tbPais".nombre_pais  
		FROM public."tbPais"
		WHERE public."tbPais".id_pais = p_id_pais;
	END;
	$$;
 5   DROP FUNCTION public.tbpais_read(p_id_pais integer);
       public          postgres    false            .           1255    18004 )   tbpais_update(integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbpais_update(p_id_pais integer, p_nombre_pais character varying) RETURNS TABLE(id_pais integer, nombre_pais character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE 
		public."tbPais" 
	SET 
		nombre_pais = p_nombre_pais 
	WHERE 
		public."tbPais".id_pais = p_id_pais;
    RETURN QUERY
	SELECT public."tbPais".id_pais, public."tbPais".nombre_pais
	FROM public."tbPais"
    WHERE public."tbPais".id_pais = p_id_pais;
END;
$$;
 X   DROP FUNCTION public.tbpais_update(p_id_pais integer, p_nombre_pais character varying);
       public          postgres    false            B           1255    18231    tbpoliza_delete(integer)    FUNCTION     .  CREATE FUNCTION public.tbpoliza_delete(p_numero_poliza integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
		resultado := true;
		BEGIN
			DELETE FROM public."tbPoliza" 
			WHERE public."tbPoliza".numero_poliza = p_numero_poliza;  
		END;
		RETURN resultado;
END;
$$;
 ?   DROP FUNCTION public.tbpoliza_delete(p_numero_poliza integer);
       public          postgres    false            -           1255    18226 T   tbpoliza_insert(integer, integer, integer, integer, date, date, real, real, integer)    FUNCTION     �  CREATE FUNCTION public.tbpoliza_insert(p_id_agencia_seguro integer, p_numero_identidad_cliente integer, p_id_estado_poliza integer, p_id_tipo_seguro integer, p_fecha_inicio date, p_fecha_fin date, p_prima_mensual real, p_monto_total_asegurado real, p_id_tipo_cobertura integer) RETURNS TABLE(numero_poliza integer, id_agencia_seguro integer, numero_identidad_cliente integer, id_estado_poliza integer, id_tipo_seguro integer, fecha_inicio date, fecha_fin date, prima_mensual real, monto_total_asegurado real, id_tipo_cobertura integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
		INSERT INTO public."tbPoliza" (id_agencia_seguro , numero_identidad_cliente , id_estado_poliza, 
			   id_tipo_seguro , fecha_inicio , fecha_fin , 
			   prima_mensual , monto_total_asegurado, id_tipo_cobertura) 
		VALUES (p_id_agencia_seguro, p_numero_identidad_cliente,
				p_id_estado_poliza, p_id_tipo_seguro,
				p_fecha_inicio, p_fecha_fin, p_prima_mensual,
				p_monto_total_asegurado, p_id_tipo_cobertura);
END;
$$;
   DROP FUNCTION public.tbpoliza_insert(p_id_agencia_seguro integer, p_numero_identidad_cliente integer, p_id_estado_poliza integer, p_id_tipo_seguro integer, p_fecha_inicio date, p_fecha_fin date, p_prima_mensual real, p_monto_total_asegurado real, p_id_tipo_cobertura integer);
       public          postgres    false            W           1255    18230    tbpoliza_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbpoliza_read(p_numero_poliza integer) RETURNS TABLE(numero_poliza integer, id_agencia_seguro integer, numero_identidad_cliente integer, id_estado_poliza integer, id_tipo_seguro integer, fecha_inicio date, fecha_fin date, prima_mensual double precision, monto_total_asegurado double precision, id_tipo_cobertura integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
		RETURN QUERY
		SELECT public."tbPoliza".numero_poliza, public."tbPoliza".id_agencia_seguro , public."tbPoliza".numero_identidad_cliente , 
			   public."tbPoliza".id_estado_poliza, 
			   public."tbPoliza".id_tipo_seguro , 
			   public."tbPoliza".fecha_inicio , public."tbPoliza".fecha_fin , 
			   public."tbPoliza".prima_mensual , public."tbPoliza".monto_total_asegurado, 
			   public."tbPoliza".id_tipo_cobertura
			   FROM public."tbPoliza" 
			   WHERE public."tbPoliza".numero_poliza = p_numero_poliza ;
END;
$$;
 =   DROP FUNCTION public.tbpoliza_read(p_numero_poliza integer);
       public          postgres    false                       1255    18227 ]   tbpoliza_update(integer, integer, integer, integer, integer, date, date, real, real, integer)    FUNCTION       CREATE FUNCTION public.tbpoliza_update(p_numero_poliza integer, p_id_agencia_seguro integer, p_numero_identidad_cliente integer, p_id_estado_poliza integer, p_id_tipo_seguro integer, p_fecha_inicio date, p_fecha_fin date, p_prima_mensual real, p_monto_total_asegurado real, p_id_tipo_cobertura integer) RETURNS TABLE(numero_poliza integer, id_agencia_seguro integer, numero_identidad_cliente integer, id_estado_poliza integer, id_tipo_seguro integer, fecha_inicio date, fecha_fin date, prima_mensual real, monto_total_asegurado real, id_tipo_cobertura integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
		UPDATE public."tbPoliza" 
		SET id_agencia_seguro=p_id_agencia_seguro , numero_identidad_cliente=p_numero_identidad_cliente , 
			id_estado_poliza=p_id_estado_poliza,
			id_tipo_seguro=p_id_tipo_seguro , fecha_inicio=p_fecha_inicio , fecha_fin=p_fecha_fin , 
			prima_mensual=p_prima_mensual , monto_total_asegurado=p_monto_total_asegurado, 
			id_tipo_cobertura=p_id_tipo_cobertura
			   WHERE public."tbPoliza".numero_poliza = p_numero_poliza;
END;
$$;
 .  DROP FUNCTION public.tbpoliza_update(p_numero_poliza integer, p_id_agencia_seguro integer, p_numero_identidad_cliente integer, p_id_estado_poliza integer, p_id_tipo_seguro integer, p_fecha_inicio date, p_fecha_fin date, p_prima_mensual real, p_monto_total_asegurado real, p_id_tipo_cobertura integer);
       public          postgres    false            M           1255    18237 8   tbporcentparticipacion_delete(integer, integer, integer)    FUNCTION     .  CREATE FUNCTION public.tbporcentparticipacion_delete(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	resultado := true;
	BEGIN
		DELETE FROM public."tbPorcentParticipacion"
		WHERE public."tbPorcentParticipacion".id_agencia_seguro=p_id_agencia_seguro AND
		public."tbPorcentParticipacion".id_tipo_seguro=p_id_tipo_seguro AND
		public."tbPorcentParticipacion".id_comp_reaseguradora=p_id_comp_reaseguradora;
	END;
	RETURN resultado;
END;
$$;
 �   DROP FUNCTION public.tbporcentparticipacion_delete(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer);
       public          postgres    false                       1255    18232 J   tbporcentparticipacion_insert(integer, integer, integer, double precision)    FUNCTION     [  CREATE FUNCTION public.tbporcentparticipacion_insert(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer, p_porciento_participacion double precision) RETURNS TABLE(id_agencia_seguro integer, id_tipo_seguro integer, id_comp_reaseguradora integer, porciento_participacion double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbPorcentParticipacion" (id_agencia_seguro , id_tipo_seguro , id_comp_reaseguradora , porciento_participacion)
	VALUES (p_id_agencia_seguro , p_id_tipo_seguro, p_id_comp_reaseguradora, p_porciento_participacion);
END;
$$;
 �   DROP FUNCTION public.tbporcentparticipacion_insert(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer, p_porciento_participacion double precision);
       public          postgres    false            ,           1255    18235 6   tbporcentparticipacion_read(integer, integer, integer)    FUNCTION     ;  CREATE FUNCTION public.tbporcentparticipacion_read(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer) RETURNS TABLE(id_agencia_seguro integer, id_tipo_seguro integer, id_comp_reaseguradora integer, porciento_participacion double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbPorcentParticipacion".id_agencia_seguro,
	public."tbPorcentParticipacion".id_tipo_seguro,
	public."tbPorcentParticipacion".id_comp_reaseguradora,
	public."tbPorcentParticipacion".porciento_participacion
	FROM public."tbPorcentParticipacion"
	WHERE public."tbPorcentParticipacion".id_agencia_seguro=p_id_agencia_seguro AND
	public."tbPorcentParticipacion".id_tipo_seguro=p_id_tipo_seguro AND
	public."tbPorcentParticipacion".id_comp_reaseguradora=p_id_comp_reaseguradora ;
END;
$$;
 �   DROP FUNCTION public.tbporcentparticipacion_read(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer);
       public          postgres    false                       1255    18233 J   tbporcentparticipacion_update(integer, integer, integer, double precision)    FUNCTION     �  CREATE FUNCTION public.tbporcentparticipacion_update(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer, p_porciento_participacion double precision) RETURNS TABLE(id_agencia_seguro integer, id_tipo_seguro integer, id_comp_reaseguradora integer, porciento_participacion double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbPorcentParticipacion" SET porciento_participacion = p_porciento_participacion 
	WHERE public."tbPorcentParticipacion".id_agencia_seguro=p_id_agencia_seguro AND
	public."tbPorcentParticipacion".id_tipo_seguro=p_id_tipo_seguro AND
	public."tbPorcentParticipacion".id_comp_reaseguradora=p_id_comp_reaseguradora ;
END;
$$;
 �   DROP FUNCTION public.tbporcentparticipacion_update(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer, p_porciento_participacion double precision);
       public          postgres    false                       1255    19358 0   tbprimamensual_delete(integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.tbprimamensual_delete(p_numero_poliza integer, p_mes integer, p_anno integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	 resultado := true;
	 BEGIN
	 DELETE FROM public."tbPrimaMensual"
	 WHERE  public."tbPrimaMensual".numero_poliza=p_numero_poliza AND  
			public."tbPrimaMensual".mes=p_mes AND  
			public."tbPrimaMensual".anno=p_anno;
	 END;
	 RETURN resultado;
END;
$$;
 d   DROP FUNCTION public.tbprimamensual_delete(p_numero_poliza integer, p_mes integer, p_anno integer);
       public          postgres    false                       1255    19354 B   tbprimamensual_insert(integer, double precision, integer, integer)    FUNCTION     �  CREATE FUNCTION public.tbprimamensual_insert(p_numero_poliza integer, p_monto_pagado double precision, p_mes integer, p_anno integer) RETURNS TABLE(numero_poliza integer, monto_pagado double precision, mes integer, anno integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbPrimaMensual" (numero_poliza , monto_pagado , mes , anno )
	VALUES (p_numero_poliza , p_monto_pagado , p_mes , p_anno);
END;
$$;
 �   DROP FUNCTION public.tbprimamensual_insert(p_numero_poliza integer, p_monto_pagado double precision, p_mes integer, p_anno integer);
       public          postgres    false                       1255    19357 .   tbprimamensual_read(integer, integer, integer)    FUNCTION     U  CREATE FUNCTION public.tbprimamensual_read(p_numero_poliza integer, p_mes integer, p_anno integer) RETURNS TABLE(numero_poliza integer, monto_pagado double precision, mes integer, anno integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbPrimaMensual".numero_poliza,
		   public."tbPrimaMensual".monto_pagado,
		   public."tbPrimaMensual".mes, 
		   public."tbPrimaMensual".anno
	 FROM 	public."tbPrimaMensual"
	 WHERE  public."tbPrimaMensual".numero_poliza=p_numero_poliza AND  
			public."tbPrimaMensual".mes=p_mes AND  
			public."tbPrimaMensual".anno=p_anno;
END;
$$;
 b   DROP FUNCTION public.tbprimamensual_read(p_numero_poliza integer, p_mes integer, p_anno integer);
       public          postgres    false            *           1255    19356 B   tbprimamensual_update(integer, double precision, integer, integer)    FUNCTION     �  CREATE FUNCTION public.tbprimamensual_update(p_numero_poliza integer, p_monto_pagado double precision, p_mes integer, p_anno integer) RETURNS TABLE(numero_poliza integer, monto_pagado double precision, mes integer, anno integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbPrimaMensual" SET monto_pagado=p_monto_pagado 
	 WHERE  public."tbPrimaMensual".numero_poliza=p_numero_poliza AND  
			public."tbPrimaMensual".mes=p_mes AND  
			public."tbPrimaMensual".anno=p_anno;
END;
$$;
 �   DROP FUNCTION public.tbprimamensual_update(p_numero_poliza integer, p_monto_pagado double precision, p_mes integer, p_anno integer);
       public          postgres    false            8           1255    18262    tbreclamacion_delete(integer)    FUNCTION     @  CREATE FUNCTION public.tbreclamacion_delete(p_numero_reclamacion integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	resultado := true;
	BEGIN
		DELETE FROM public."tbReclamacion" 	WHERE public."tbReclamacion".numero_reclamacion=p_numero_reclamacion;
	END;
	RETURN resultado;
END;
$$;
 I   DROP FUNCTION public.tbreclamacion_delete(p_numero_reclamacion integer);
       public          postgres    false            (           1255    18258 Y   tbreclamacion_insert(integer, integer, integer, date, double precision, double precision)    FUNCTION     $  CREATE FUNCTION public.tbreclamacion_insert(p_numero_poliza integer, p_id_estado_reclamacion integer, p_id_tipo_siniestro integer, p_fecha_siniestro date, p_monto_reclamado double precision, p_monto_indemnizado double precision) RETURNS TABLE(numero_reclamacion integer, numero_poliza integer, id_estado_reclamacion integer, id_tipo_siniestro integer, fecha_siniestro date, monto_reclamado double precision, monto_indemnizado double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN  
	INSERT INTO public."tbReclamacion" (numero_poliza, id_estado_reclamacion, 
										  id_tipo_siniestro, fecha_siniestro , 
										  monto_reclamado, monto_indemnizado) 
	VALUES (p_numero_poliza , p_id_estado_reclamacion, p_id_tipo_siniestro, 
			p_fecha_siniestro, p_monto_reclamado, p_monto_indemnizado);
END;
$$;
 �   DROP FUNCTION public.tbreclamacion_insert(p_numero_poliza integer, p_id_estado_reclamacion integer, p_id_tipo_siniestro integer, p_fecha_siniestro date, p_monto_reclamado double precision, p_monto_indemnizado double precision);
       public          postgres    false            )           1255    18261    tbreclamacion_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbreclamacion_read(p_numero_reclamacion integer) RETURNS TABLE(numero_reclamacion integer, numero_poliza integer, id_estado_reclamacion integer, id_tipo_siniestro integer, fecha_siniestro date, monto_reclamado double precision, monto_indemnizado double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbReclamacion".numero_reclamacion, public."tbReclamacion".numero_poliza, public."tbReclamacion".id_estado_reclamacion, 
		   public."tbReclamacion".id_tipo_siniestro, public."tbReclamacion".fecha_siniestro, 
		   public."tbReclamacion".monto_reclamado, public."tbReclamacion".monto_indemnizado 
	FROM public."tbReclamacion"
	WHERE public."tbReclamacion".numero_reclamacion=p_numero_reclamacion;
END;
$$;
 G   DROP FUNCTION public.tbreclamacion_read(p_numero_reclamacion integer);
       public          postgres    false            :           1255    18259 b   tbreclamacion_update(integer, integer, integer, integer, date, double precision, double precision)    FUNCTION     q  CREATE FUNCTION public.tbreclamacion_update(p_numero_reclamacion integer, p_numero_poliza integer, p_id_estado_reclamacion integer, p_id_tipo_siniestro integer, p_fecha_siniestro date, p_monto_reclamado double precision, p_monto_indemnizado double precision) RETURNS TABLE(numero_reclamacion integer, numero_poliza integer, id_estado_reclamacion integer, id_tipo_siniestro integer, fecha_siniestro date, monto_reclamado double precision, monto_indemnizado double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN  
	UPDATE public."tbReclamacion" SET numero_poliza=p_numero_poliza, id_estado_reclamacion=p_id_estado_reclamacion, 
										  id_tipo_siniestro=p_id_tipo_siniestro, fecha_siniestro=p_fecha_siniestro , 
										  monto_reclamado=p_monto_reclamado, monto_indemnizado=p_monto_indemnizado 
	WHERE public."tbReclamacion".numero_reclamacion=p_numero_reclamacion;
END;
$$;
   DROP FUNCTION public.tbreclamacion_update(p_numero_reclamacion integer, p_numero_poliza integer, p_id_estado_reclamacion integer, p_id_tipo_siniestro integer, p_fecha_siniestro date, p_monto_reclamado double precision, p_monto_indemnizado double precision);
       public          postgres    false            "           1255    18275 +   tbsegurosdeagencia_delete(integer, integer)    FUNCTION     �  CREATE FUNCTION public.tbsegurosdeagencia_delete(p_id_tipo_seguro integer, p_id_agencia_seguro integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	resultado:=true;
	BEGIN
		DELETE FROM public."tbSegurosDeAgencia" 
		WHERE 
			public."tbSegurosDeAgencia".id_agencia_seguro= p_id_agencia_seguro AND
		  	public."tbSegurosDeAgencia".id_tipo_seguro= p_id_tipo_seguro;
	END;
	RETURN resultado;
END;
$$;
 g   DROP FUNCTION public.tbsegurosdeagencia_delete(p_id_tipo_seguro integer, p_id_agencia_seguro integer);
       public          postgres    false            6           1255    18265 +   tbsegurosdeagencia_insert(integer, integer)    FUNCTION     U  CREATE FUNCTION public.tbsegurosdeagencia_insert(p_id_tipo_seguro integer, p_id_agencia_seguro integer) RETURNS TABLE(id_tipo_seguro integer, id_agencia_seguro integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbSegurosDeAgencia" (id_tipo_seguro, id_agencia_seguro)
	VALUES (p_id_tipo_seguro, p_id_agencia_seguro);
END;
$$;
 g   DROP FUNCTION public.tbsegurosdeagencia_insert(p_id_tipo_seguro integer, p_id_agencia_seguro integer);
       public          postgres    false            ?           1255    18269     tbsegurosdeagencia_read(integer)    FUNCTION       CREATE FUNCTION public.tbsegurosdeagencia_read(p_id_agencia_seguro integer) RETURNS TABLE(nombre_tipo_seguro character varying, id_agencia_seguro integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbTipoSeguro".nombre_tipo_seguro, public."tbSegurosDeAgencia".id_agencia_seguro 
	FROM public."tbSegurosDeAgencia", public."tbTipoSeguro"
	WHERE public."tbSegurosDeAgencia".id_agencia_seguro= p_id_agencia_seguro AND
		  public."tbSegurosDeAgencia".id_tipo_seguro= public."tbTipoSeguro".id_tipo_seguro;
END;
$$;
 K   DROP FUNCTION public.tbsegurosdeagencia_read(p_id_agencia_seguro integer);
       public          postgres    false            @           1255    18263    tbsexo_read(integer)    FUNCTION     /  CREATE FUNCTION public.tbsexo_read(p_id_sexo integer) RETURNS TABLE(id_sexo integer, nombre_sexo character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbSexo".id_sexo, public."tbSexo".nombre_sexo
	FROM public."tbSexo"
	WHERE public."tbSexo".id_sexo = p_id_sexo;
END;
$$;
 5   DROP FUNCTION public.tbsexo_read(p_id_sexo integer);
       public          postgres    false            V           1255    18291    tbtipocobertura_delete(integer)    FUNCTION     D  CREATE FUNCTION public.tbtipocobertura_delete(p_id_tipo_cobertura integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	resultado := true;
	BEGIN
		DELETE FROM public."tbTipoCobertura" WHERE public."tbTipoCobertura".id_tipo_cobertura =p_id_tipo_cobertura; 
	END;
	RETURN resultado;
END;
$$;
 J   DROP FUNCTION public.tbtipocobertura_delete(p_id_tipo_cobertura integer);
       public          postgres    false                       1255    18279 )   tbtipocobertura_insert(character varying)    FUNCTION     9  CREATE FUNCTION public.tbtipocobertura_insert(p_nombre_tipo_cobertura character varying) RETURNS TABLE(id_tipo_cobertura integer, nombre_tipo_cobertura character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbTipoCobertura" (nombre_tipo_cobertura) VALUES (p_nombre_tipo_cobertura);
END;
$$;
 X   DROP FUNCTION public.tbtipocobertura_insert(p_nombre_tipo_cobertura character varying);
       public          postgres    false            5           1255    18296    tbtipocobertura_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbtipocobertura_read(p_id_tipo_cobertura integer) RETURNS TABLE(id_tipo_cobertura integer, nombre_tipo_cobertura character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbTipoCobertura".id_tipo_cobertura, public."tbTipoCobertura".nombre_tipo_cobertura
	FROM public."tbTipoCobertura" 
	WHERE public."tbTipoCobertura".id_tipo_cobertura= p_id_tipo_cobertura;
END;
$$;
 H   DROP FUNCTION public.tbtipocobertura_read(p_id_tipo_cobertura integer);
       public          postgres    false            !           1255    18294 2   tbtipocobertura_update(integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbtipocobertura_update(p_id_tipo_cobertura integer, p_nombre_tipo_cobertura character varying) RETURNS TABLE(id_tipo_cobertura integer, nombre_tipo_cobertura character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbTipoCobertura" SET nombre_tipo_cobertura= p_nombre_tipo_cobertura
	WHERE public."tbTipoCobertura".id_tipo_cobertura= p_id_tipo_cobertura;
END;
$$;
 u   DROP FUNCTION public.tbtipocobertura_update(p_id_tipo_cobertura integer, p_nombre_tipo_cobertura character varying);
       public          postgres    false            '           1255    18289    tbtiporeaseguro_delete(integer)    FUNCTION     D  CREATE FUNCTION public.tbtiporeaseguro_delete(p_id_tipo_reaseguro integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	resultado := true;
	BEGIN
		DELETE FROM public."tbTipoReaseguro" WHERE public."tbTipoReaseguro".id_tipo_reaseguro =p_id_tipo_reaseguro; 
	END;
	RETURN resultado;
END;
$$;
 J   DROP FUNCTION public.tbtiporeaseguro_delete(p_id_tipo_reaseguro integer);
       public          postgres    false                       1255    18281 )   tbtiporeaseguro_insert(character varying)    FUNCTION     9  CREATE FUNCTION public.tbtiporeaseguro_insert(p_nombre_tipo_reaseguro character varying) RETURNS TABLE(id_tipo_reaseguro integer, nombre_tipo_reaseguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbTipoReaseguro" (nombre_tipo_reaseguro) VALUES (p_nombre_tipo_reaseguro);
END;
$$;
 X   DROP FUNCTION public.tbtiporeaseguro_insert(p_nombre_tipo_reaseguro character varying);
       public          postgres    false            P           1255    18298    tbtiporeaseguro_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbtiporeaseguro_read(p_id_tipo_reaseguro integer) RETURNS TABLE(id_tipo_reaseguro integer, nombre_tipo_reaseguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbTipoReaseguro".id_tipo_reaseguro, public."tbTipoReaseguro".nombre_tipo_reaseguro
	FROM public."tbTipoReaseguro" 
	WHERE public."tbTipoReaseguro".id_tipo_reaseguro= p_id_tipo_reaseguro;
END;
$$;
 H   DROP FUNCTION public.tbtiporeaseguro_read(p_id_tipo_reaseguro integer);
       public          postgres    false            R           1255    18285 2   tbtiporeaseguro_update(integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbtiporeaseguro_update(p_id_tipo_reaseguro integer, p_nombre_tipo_reaseguro character varying) RETURNS TABLE(id_tipo_reaseguro integer, nombre_tipo_reaseguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbTipoReaseguro" SET nombre_tipo_reaseguro= p_nombre_tipo_reaseguro
	WHERE public."tbTipoReaseguro".id_tipo_reaseguro= p_id_tipo_reaseguro;
END;
$$;
 u   DROP FUNCTION public.tbtiporeaseguro_update(p_id_tipo_reaseguro integer, p_nombre_tipo_reaseguro character varying);
       public          postgres    false            3           1255    18288    tbtiposeguro_delete(integer)    FUNCTION     2  CREATE FUNCTION public.tbtiposeguro_delete(p_id_tipo_seguro integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	resultado := true;
	BEGIN
		DELETE FROM public."tbTipoSeguro" WHERE public."tbTipoSeguro".id_tipo_seguro =p_id_tipo_seguro; 
	END;
	RETURN resultado;
END;
$$;
 D   DROP FUNCTION public.tbtiposeguro_delete(p_id_tipo_seguro integer);
       public          postgres    false            
           1255    18301 &   tbtiposeguro_insert(character varying)    FUNCTION       CREATE FUNCTION public.tbtiposeguro_insert(p_nombre_seguro character varying) RETURNS TABLE(id_tipo_seguro integer, nombre_tipo_seguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbTipoSeguro" (nombre_tipo_seguro) VALUES (p_nombre_seguro);
END;
$$;
 M   DROP FUNCTION public.tbtiposeguro_insert(p_nombre_seguro character varying);
       public          postgres    false            S           1255    18297    tbtiposeguro_read(integer)    FUNCTION     ~  CREATE FUNCTION public.tbtiposeguro_read(p_id_tipo_seguro integer) RETURNS TABLE(id_tipo_seguro integer, nombre_tipo_seguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbTipoSeguro".id_tipo_seguro, public."tbTipoSeguro".nombre_tipo_seguro
	FROM public."tbTipoSeguro" 
	WHERE public."tbTipoSeguro".id_tipo_seguro= p_id_tipo_seguro;
END;
$$;
 B   DROP FUNCTION public.tbtiposeguro_read(p_id_tipo_seguro integer);
       public          postgres    false                        1255    18284 /   tbtiposeguro_update(integer, character varying)    FUNCTION     q  CREATE FUNCTION public.tbtiposeguro_update(p_id_tipo_seguro integer, p_nombre_tipo_seguro character varying) RETURNS TABLE(id_tipo_seguro integer, nombre_tipo_seguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbTipoSeguro" SET nombre_tipo_seguro= p_nombre_tipo_seguro
	WHERE public."tbTipoSeguro".id_tipo_seguro= p_id_tipo_seguro;
END;
$$;
 l   DROP FUNCTION public.tbtiposeguro_update(p_id_tipo_seguro integer, p_nombre_tipo_seguro character varying);
       public          postgres    false            G           1255    18290    tbtiposiniestro_delete(integer)    FUNCTION     D  CREATE FUNCTION public.tbtiposiniestro_delete(p_id_tipo_siniestro integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	resultado := true;
	BEGIN
		DELETE FROM public."tbTipoSiniestro" WHERE public."tbTipoSiniestro".id_tipo_siniestro =p_id_tipo_siniestro; 
	END;
	RETURN resultado;
END;
$$;
 J   DROP FUNCTION public.tbtiposiniestro_delete(p_id_tipo_siniestro integer);
       public          postgres    false                       1255    18283 )   tbtiposiniestro_insert(character varying)    FUNCTION     %  CREATE FUNCTION public.tbtiposiniestro_insert(p_nombre_siniestro character varying) RETURNS TABLE(id_tipo_siniestro integer, nombre_siniestro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbTipoSiniestro" (nombre_siniestro) VALUES (p_nombre_siniestro);
END;
$$;
 S   DROP FUNCTION public.tbtiposiniestro_insert(p_nombre_siniestro character varying);
       public          postgres    false                       1255    18300    tbtiposiniestro_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbtiposiniestro_read(p_id_tipo_siniestro integer) RETURNS TABLE(id_tipo_siniestro integer, nombre_siniestro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbTipoSiniestro".id_tipo_siniestro, public."tbTipoSiniestro".nombre_siniestro 
	FROM public."tbTipoSiniestro" 
	WHERE public."tbTipoSiniestro".id_tipo_siniestro= p_id_tipo_siniestro;
END;
$$;
 H   DROP FUNCTION public.tbtiposiniestro_read(p_id_tipo_siniestro integer);
       public          postgres    false            J           1255    18293 2   tbtiposiniestro_update(integer, character varying)    FUNCTION     ~  CREATE FUNCTION public.tbtiposiniestro_update(p_id_tipo_siniestro integer, p_nombre_siniestro character varying) RETURNS TABLE(id_tipo_siniestro integer, nombre_siniestro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbTipoSiniestro" SET nombre_siniestro= p_nombre_siniestro
	WHERE public."tbTipoSiniestro".id_tipo_siniestro= p_id_tipo_siniestro;
END;
$$;
 p   DROP FUNCTION public.tbtiposiniestro_update(p_id_tipo_siniestro integer, p_nombre_siniestro character varying);
       public          postgres    false            �            1259    17766 	   tbCliente    TABLE     �  CREATE TABLE public."tbCliente" (
    numero_identidad_cliente integer NOT NULL,
    id_pais integer NOT NULL,
    id_sexo integer NOT NULL,
    nombre_cliente character varying(50) NOT NULL,
    apellido_cliente character varying(50) NOT NULL,
    edad integer NOT NULL,
    direccion_postal character varying(255) NOT NULL,
    telefono character varying(50) NOT NULL,
    correo_electronico character varying(255) NOT NULL,
    carnet_identidad character varying(11) NOT NULL
);
    DROP TABLE public."tbCliente";
       public         heap    postgres    false            �            1259    17789    tbEstadoReclamacion    TABLE     �   CREATE TABLE public."tbEstadoReclamacion" (
    id_estado_reclamacion integer NOT NULL,
    nombre_estado_reclamacion character varying(50) NOT NULL
);
 )   DROP TABLE public."tbEstadoReclamacion";
       public         heap    postgres    false            �            1259    17822    tbPoliza    TABLE     �  CREATE TABLE public."tbPoliza" (
    numero_poliza integer NOT NULL,
    id_agencia_seguro integer NOT NULL,
    numero_identidad_cliente integer NOT NULL,
    id_estado_poliza integer NOT NULL,
    id_tipo_seguro integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    prima_mensual double precision NOT NULL,
    monto_total_asegurado double precision NOT NULL,
    id_tipo_cobertura integer NOT NULL
);
    DROP TABLE public."tbPoliza";
       public         heap    postgres    false            �            1259    17836    tbReclamacion    TABLE     C  CREATE TABLE public."tbReclamacion" (
    numero_reclamacion integer NOT NULL,
    numero_poliza integer NOT NULL,
    id_estado_reclamacion integer NOT NULL,
    id_tipo_siniestro integer NOT NULL,
    fecha_siniestro date NOT NULL,
    monto_reclamado double precision NOT NULL,
    monto_indemnizado double precision
);
 #   DROP TABLE public."tbReclamacion";
       public         heap    postgres    false            �            1259    17859    tbTipoSeguro    TABLE     �   CREATE TABLE public."tbTipoSeguro" (
    id_tipo_seguro integer NOT NULL,
    nombre_tipo_seguro character varying(50) NOT NULL
);
 "   DROP TABLE public."tbTipoSeguro";
       public         heap    postgres    false            �            1259    17866    tbTipoSiniestro    TABLE     �   CREATE TABLE public."tbTipoSiniestro" (
    id_tipo_siniestro integer NOT NULL,
    nombre_siniestro character varying(255) NOT NULL
);
 %   DROP TABLE public."tbTipoSiniestro";
       public         heap    postgres    false            �            1259    17990    reporte_estado_reclamaciones    VIEW     �  CREATE VIEW public.reporte_estado_reclamaciones AS
 SELECT "tbReclamacion".numero_reclamacion,
    "tbCliente".nombre_cliente,
    "tbReclamacion".numero_poliza,
    "tbTipoSeguro".nombre_tipo_seguro,
    "tbTipoSiniestro".nombre_siniestro,
    "tbEstadoReclamacion".nombre_estado_reclamacion,
    "tbReclamacion".fecha_siniestro,
    "tbReclamacion".monto_reclamado,
    "tbReclamacion".monto_indemnizado
   FROM public."tbReclamacion",
    public."tbTipoSiniestro",
    public."tbTipoSeguro",
    public."tbCliente",
    public."tbEstadoReclamacion"
  WHERE (("tbReclamacion".id_tipo_siniestro = "tbTipoSiniestro".id_tipo_siniestro) AND ("tbTipoSeguro".id_tipo_seguro IN ( SELECT "tbPoliza".id_tipo_seguro
           FROM public."tbPoliza"
          WHERE ("tbPoliza".numero_poliza = "tbReclamacion".numero_poliza))) AND ("tbCliente".numero_identidad_cliente IN ( SELECT "tbPoliza".numero_identidad_cliente
           FROM public."tbPoliza"
          WHERE ("tbPoliza".numero_poliza = "tbReclamacion".numero_poliza))) AND ("tbReclamacion".id_estado_reclamacion = "tbEstadoReclamacion".id_estado_reclamacion))
  ORDER BY "tbEstadoReclamacion".nombre_estado_reclamacion;
 /   DROP VIEW public.reporte_estado_reclamaciones;
       public          postgres    false    230    230    224    224    218    240    234    242    234    234    218    242    240    234    234    234    234    230            �            1259    17815    tbPais    TABLE     o   CREATE TABLE public."tbPais" (
    id_pais integer NOT NULL,
    nombre_pais character varying(50) NOT NULL
);
    DROP TABLE public."tbPais";
       public         heap    postgres    false            �            1259    19405    reporte_paises    VIEW     r   CREATE VIEW public.reporte_paises AS
 SELECT id_pais,
    nombre_pais
   FROM public."tbPais"
  ORDER BY id_pais;
 !   DROP VIEW public.reporte_paises;
       public          postgres    false    228    228            �            1259    17843    tbSexo    TABLE     k   CREATE TABLE public."tbSexo" (
    id_sexo integer NOT NULL,
    nombre_sexo character varying NOT NULL
);
    DROP TABLE public."tbSexo";
       public         heap    postgres    false                       1259    19430    reporte_roger_clientes    VIEW     �  CREATE VIEW public.reporte_roger_clientes AS
 SELECT "tbCliente".numero_identidad_cliente,
    "tbPais".nombre_pais,
    "tbSexo".nombre_sexo,
    "tbCliente".nombre_cliente,
    "tbCliente".apellido_cliente,
    "tbCliente".telefono,
    "tbCliente".correo_electronico,
    "tbCliente".carnet_identidad
   FROM public."tbCliente",
    public."tbPais",
    public."tbSexo"
  WHERE (("tbCliente".id_pais = "tbPais".id_pais) AND ("tbCliente".id_sexo = "tbSexo".id_sexo));
 )   DROP VIEW public.reporte_roger_clientes;
       public          postgres    false    218    236    236    228    228    218    218    218    218    218    218    218            �            1259    19409    reporte_tipos_de_seguros    VIEW     �   CREATE VIEW public.reporte_tipos_de_seguros AS
 SELECT id_tipo_seguro,
    nombre_tipo_seguro
   FROM public."tbTipoSeguro"
  ORDER BY id_tipo_seguro;
 +   DROP VIEW public.reporte_tipos_de_seguros;
       public          postgres    false    240    240            �            1259    19393 0   salida_cliente_con_cantidad_reclamacion_aprobada    VIEW     �   CREATE VIEW public.salida_cliente_con_cantidad_reclamacion_aprobada AS
SELECT
    NULL::character varying(50) AS nombre_cliente,
    NULL::integer AS numero_identidad_cliente,
    NULL::bigint AS count,
    NULL::double precision AS sum;
 C   DROP VIEW public.salida_cliente_con_cantidad_reclamacion_aprobada;
       public          postgres    false            �            1259    19384 1   salida_cliente_con_cantidad_reclamacion_rechazada    VIEW     �   CREATE VIEW public.salida_cliente_con_cantidad_reclamacion_rechazada AS
SELECT
    NULL::character varying(50) AS nombre_cliente,
    NULL::integer AS numero_identidad_cliente,
    NULL::bigint AS count;
 D   DROP VIEW public.salida_cliente_con_cantidad_reclamacion_rechazada;
       public          postgres    false                        1259    19426    salida_listado_polizas_vencidas    VIEW       CREATE VIEW public.salida_listado_polizas_vencidas AS
 SELECT "tbPoliza".numero_poliza,
    "tbCliente".nombre_cliente,
    "tbTipoSeguro".nombre_tipo_seguro,
    "tbPoliza".fecha_inicio,
    "tbPoliza".fecha_fin,
    "tbPoliza".monto_total_asegurado
   FROM public."tbPoliza",
    public."tbCliente",
    public."tbTipoSeguro"
  WHERE (("tbPoliza".id_tipo_seguro = "tbTipoSeguro".id_tipo_seguro) AND ("tbPoliza".numero_identidad_cliente = "tbCliente".numero_identidad_cliente) AND ("tbPoliza".id_estado_poliza = 2));
 2   DROP VIEW public.salida_listado_polizas_vencidas;
       public          postgres    false    240    230    218    230    230    218    240    230    230    230    230            �            1259    17775    tbCompReaseguradora    TABLE     �   CREATE TABLE public."tbCompReaseguradora" (
    id_comp_reaseguradora integer NOT NULL,
    id_pais integer NOT NULL,
    id_tipo_reaseguro integer NOT NULL,
    nombre_compannia_reaseguradora character varying(255) NOT NULL
);
 )   DROP TABLE public."tbCompReaseguradora";
       public         heap    postgres    false            �            1259    17852    tbTipoReaseguro    TABLE     �   CREATE TABLE public."tbTipoReaseguro" (
    id_tipo_reaseguro integer NOT NULL,
    nombre_tipo_reaseguro character varying(50) NOT NULL
);
 %   DROP TABLE public."tbTipoReaseguro";
       public         heap    postgres    false            �            1259    19422    salida_listado_reaseguradoras    VIEW     �  CREATE VIEW public.salida_listado_reaseguradoras AS
 SELECT "tbCompReaseguradora".nombre_compannia_reaseguradora,
    "tbPais".nombre_pais,
    "tbTipoReaseguro".nombre_tipo_reaseguro
   FROM public."tbPais",
    public."tbTipoReaseguro",
    public."tbCompReaseguradora"
  WHERE (("tbCompReaseguradora".id_tipo_reaseguro = "tbTipoReaseguro".id_tipo_reaseguro) AND ("tbCompReaseguradora".id_pais = "tbPais".id_pais));
 0   DROP VIEW public.salida_listado_reaseguradoras;
       public          postgres    false    228    220    220    220    228    238    238            �            1259    19416    salida_listado_reclamaciones    VIEW     �  CREATE VIEW public.salida_listado_reclamaciones AS
 SELECT "tbCliente".nombre_cliente,
    "tbReclamacion".numero_poliza,
    "tbTipoSeguro".nombre_tipo_seguro,
    "tbReclamacion".numero_reclamacion,
    "tbTipoSiniestro".nombre_siniestro,
    "tbReclamacion".fecha_siniestro,
    "tbReclamacion".monto_reclamado,
    "tbEstadoReclamacion".nombre_estado_reclamacion,
    "tbReclamacion".monto_indemnizado
   FROM public."tbReclamacion",
    public."tbTipoSiniestro",
    public."tbTipoSeguro",
    public."tbCliente",
    public."tbEstadoReclamacion"
  WHERE (("tbReclamacion".id_tipo_siniestro = "tbTipoSiniestro".id_tipo_siniestro) AND ("tbTipoSeguro".id_tipo_seguro IN ( SELECT "tbPoliza".id_tipo_seguro
           FROM public."tbPoliza"
          WHERE ("tbPoliza".numero_poliza = "tbReclamacion".numero_poliza))) AND ("tbCliente".numero_identidad_cliente IN ( SELECT "tbPoliza".numero_identidad_cliente
           FROM public."tbPoliza"
          WHERE ("tbPoliza".numero_poliza = "tbReclamacion".numero_poliza))) AND ("tbReclamacion".id_estado_reclamacion = "tbEstadoReclamacion".id_estado_reclamacion))
  ORDER BY "tbReclamacion".numero_reclamacion;
 /   DROP VIEW public.salida_listado_reclamaciones;
       public          postgres    false    224    242    240    240    234    234    234    234    234    234    242    234    230    230    230    218    218    224            �            1259    17757    tbAgenciaSeguro    TABLE     �  CREATE TABLE public."tbAgenciaSeguro" (
    id_agencia_seguro integer NOT NULL,
    nombre_agencia_seguro character varying(50) NOT NULL,
    direccion_postal character varying(255) NOT NULL,
    telefono character varying(50) NOT NULL,
    correo_electronico character varying(255) NOT NULL,
    nombre_director_general character varying(50) NOT NULL,
    nombre_jefe_departamento_seguros character varying(50) NOT NULL,
    nombre_jefe_departamento_reclamaciones character varying(50) NOT NULL
);
 %   DROP TABLE public."tbAgenciaSeguro";
       public         heap    postgres    false            �            1259    17756 %   tbAgenciaSeguro_id_agencia_seguro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbAgenciaSeguro_id_agencia_seguro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."tbAgenciaSeguro_id_agencia_seguro_seq";
       public          postgres    false    216            ;           0    0 %   tbAgenciaSeguro_id_agencia_seguro_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."tbAgenciaSeguro_id_agencia_seguro_seq" OWNED BY public."tbAgenciaSeguro".id_agencia_seguro;
          public          postgres    false    215            �            1259    17765 &   tbCliente_numero_identidad_cliente_seq    SEQUENCE     �   CREATE SEQUENCE public."tbCliente_numero_identidad_cliente_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public."tbCliente_numero_identidad_cliente_seq";
       public          postgres    false    218            <           0    0 &   tbCliente_numero_identidad_cliente_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public."tbCliente_numero_identidad_cliente_seq" OWNED BY public."tbCliente".numero_identidad_cliente;
          public          postgres    false    217            �            1259    17774 -   tbCompReaseguradora_id_comp_reaseguradora_seq    SEQUENCE     �   CREATE SEQUENCE public."tbCompReaseguradora_id_comp_reaseguradora_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 F   DROP SEQUENCE public."tbCompReaseguradora_id_comp_reaseguradora_seq";
       public          postgres    false    220            =           0    0 -   tbCompReaseguradora_id_comp_reaseguradora_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."tbCompReaseguradora_id_comp_reaseguradora_seq" OWNED BY public."tbCompReaseguradora".id_comp_reaseguradora;
          public          postgres    false    219            �            1259    17782    tbEstadoPoliza    TABLE     �   CREATE TABLE public."tbEstadoPoliza" (
    id_estado_poliza integer NOT NULL,
    nombre_estado_poliza character varying(50) NOT NULL
);
 $   DROP TABLE public."tbEstadoPoliza";
       public         heap    postgres    false            �            1259    17781 #   tbEstadoPoliza_id_estado_poliza_seq    SEQUENCE     �   CREATE SEQUENCE public."tbEstadoPoliza_id_estado_poliza_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."tbEstadoPoliza_id_estado_poliza_seq";
       public          postgres    false    222            >           0    0 #   tbEstadoPoliza_id_estado_poliza_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public."tbEstadoPoliza_id_estado_poliza_seq" OWNED BY public."tbEstadoPoliza".id_estado_poliza;
          public          postgres    false    221            �            1259    17788 -   tbEstadoReclamacion_id_estado_reclamacion_seq    SEQUENCE     �   CREATE SEQUENCE public."tbEstadoReclamacion_id_estado_reclamacion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 F   DROP SEQUENCE public."tbEstadoReclamacion_id_estado_reclamacion_seq";
       public          postgres    false    224            ?           0    0 -   tbEstadoReclamacion_id_estado_reclamacion_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."tbEstadoReclamacion_id_estado_reclamacion_seq" OWNED BY public."tbEstadoReclamacion".id_estado_reclamacion;
          public          postgres    false    223            �            1259    17800    tbMotivoCancelacionPoliza    TABLE     ~   CREATE TABLE public."tbMotivoCancelacionPoliza" (
    numero_poliza integer NOT NULL,
    descripcion_motivo text NOT NULL
);
 /   DROP TABLE public."tbMotivoCancelacionPoliza";
       public         heap    postgres    false            �            1259    17805    tbMotivoRechazoReclamacion    TABLE     �   CREATE TABLE public."tbMotivoRechazoReclamacion" (
    numero_reclamacion integer NOT NULL,
    motivo_rechazo text NOT NULL
);
 0   DROP TABLE public."tbMotivoRechazoReclamacion";
       public         heap    postgres    false            �            1259    17814    tbPais_id_pais_seq    SEQUENCE     �   CREATE SEQUENCE public."tbPais_id_pais_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."tbPais_id_pais_seq";
       public          postgres    false    228            @           0    0    tbPais_id_pais_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."tbPais_id_pais_seq" OWNED BY public."tbPais".id_pais;
          public          postgres    false    227            �            1259    17821    tbPoliza_numero_poliza_seq    SEQUENCE     �   CREATE SEQUENCE public."tbPoliza_numero_poliza_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."tbPoliza_numero_poliza_seq";
       public          postgres    false    230            A           0    0    tbPoliza_numero_poliza_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."tbPoliza_numero_poliza_seq" OWNED BY public."tbPoliza".numero_poliza;
          public          postgres    false    229            �            1259    17829    tbPorcentParticipacion    TABLE     �   CREATE TABLE public."tbPorcentParticipacion" (
    id_agencia_seguro integer NOT NULL,
    id_tipo_seguro integer NOT NULL,
    id_comp_reaseguradora integer NOT NULL,
    porciento_participacion double precision NOT NULL
);
 ,   DROP TABLE public."tbPorcentParticipacion";
       public         heap    postgres    false            �            1259    17828 ,   tbPorcentParticipacion_id_agencia_seguro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbPorcentParticipacion_id_agencia_seguro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public."tbPorcentParticipacion_id_agencia_seguro_seq";
       public          postgres    false    232            B           0    0 ,   tbPorcentParticipacion_id_agencia_seguro_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."tbPorcentParticipacion_id_agencia_seguro_seq" OWNED BY public."tbPorcentParticipacion".id_agencia_seguro;
          public          postgres    false    231            �            1259    19340    tbPrimaMensual    TABLE     �   CREATE TABLE public."tbPrimaMensual" (
    numero_poliza integer NOT NULL,
    monto_pagado double precision NOT NULL,
    mes integer NOT NULL,
    anno integer NOT NULL
);
 $   DROP TABLE public."tbPrimaMensual";
       public         heap    postgres    false            �            1259    17835 $   tbReclamacion_numero_reclamacion_seq    SEQUENCE     �   CREATE SEQUENCE public."tbReclamacion_numero_reclamacion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public."tbReclamacion_numero_reclamacion_seq";
       public          postgres    false    234            C           0    0 $   tbReclamacion_numero_reclamacion_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."tbReclamacion_numero_reclamacion_seq" OWNED BY public."tbReclamacion".numero_reclamacion;
          public          postgres    false    233                       1259    19453    tbRol    TABLE     l   CREATE TABLE public."tbRol" (
    id_rol integer NOT NULL,
    nombre_rol character varying(50) NOT NULL
);
    DROP TABLE public."tbRol";
       public         heap    postgres    false                       1259    19452    tbRol_id_rol_seq    SEQUENCE     �   CREATE SEQUENCE public."tbRol_id_rol_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."tbRol_id_rol_seq";
       public          postgres    false    259            D           0    0    tbRol_id_rol_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."tbRol_id_rol_seq" OWNED BY public."tbRol".id_rol;
          public          postgres    false    258            �            1259    18163    tbSegurosDeAgencia    TABLE     z   CREATE TABLE public."tbSegurosDeAgencia" (
    id_tipo_seguro integer NOT NULL,
    id_agencia_seguro integer NOT NULL
);
 (   DROP TABLE public."tbSegurosDeAgencia";
       public         heap    postgres    false            �            1259    17842    tbSexo_id_sexo_seq    SEQUENCE     �   CREATE SEQUENCE public."tbSexo_id_sexo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."tbSexo_id_sexo_seq";
       public          postgres    false    236            E           0    0    tbSexo_id_sexo_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."tbSexo_id_sexo_seq" OWNED BY public."tbSexo".id_sexo;
          public          postgres    false    235            �            1259    17962    tbTipoCobertura    TABLE     �   CREATE TABLE public."tbTipoCobertura" (
    id_tipo_cobertura integer NOT NULL,
    nombre_tipo_cobertura character varying NOT NULL
);
 %   DROP TABLE public."tbTipoCobertura";
       public         heap    postgres    false            �            1259    17961 %   tbTipoCobertura_id_tipo_cobertura_seq    SEQUENCE     �   CREATE SEQUENCE public."tbTipoCobertura_id_tipo_cobertura_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."tbTipoCobertura_id_tipo_cobertura_seq";
       public          postgres    false    244            F           0    0 %   tbTipoCobertura_id_tipo_cobertura_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."tbTipoCobertura_id_tipo_cobertura_seq" OWNED BY public."tbTipoCobertura".id_tipo_cobertura;
          public          postgres    false    243            �            1259    17851 %   tbTipoReaseguro_id_tipo_reaseguro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbTipoReaseguro_id_tipo_reaseguro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."tbTipoReaseguro_id_tipo_reaseguro_seq";
       public          postgres    false    238            G           0    0 %   tbTipoReaseguro_id_tipo_reaseguro_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."tbTipoReaseguro_id_tipo_reaseguro_seq" OWNED BY public."tbTipoReaseguro".id_tipo_reaseguro;
          public          postgres    false    237            �            1259    17858    tbTipoSeguro_id_tipo_seguro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbTipoSeguro_id_tipo_seguro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public."tbTipoSeguro_id_tipo_seguro_seq";
       public          postgres    false    240            H           0    0    tbTipoSeguro_id_tipo_seguro_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."tbTipoSeguro_id_tipo_seguro_seq" OWNED BY public."tbTipoSeguro".id_tipo_seguro;
          public          postgres    false    239            �            1259    17865 %   tbTipoSiniestro_id_tipo_siniestro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbTipoSiniestro_id_tipo_siniestro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."tbTipoSiniestro_id_tipo_siniestro_seq";
       public          postgres    false    242            I           0    0 %   tbTipoSiniestro_id_tipo_siniestro_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."tbTipoSiniestro_id_tipo_siniestro_seq" OWNED BY public."tbTipoSiniestro".id_tipo_siniestro;
          public          postgres    false    241                       1259    19459 	   tbUserRol    TABLE     b   CREATE TABLE public."tbUserRol" (
    id_usuario integer NOT NULL,
    id_rol integer NOT NULL
);
    DROP TABLE public."tbUserRol";
       public         heap    postgres    false            �            1259    19367 
   tbUsuarios    TABLE     �   CREATE TABLE public."tbUsuarios" (
    id_usuario integer NOT NULL,
    nombre_usuario text NOT NULL,
    contrasenna text NOT NULL
);
     DROP TABLE public."tbUsuarios";
       public         heap    postgres    false            �            1259    19366    tbUsuarios_id_usuario_seq    SEQUENCE     �   CREATE SEQUENCE public."tbUsuarios_id_usuario_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."tbUsuarios_id_usuario_seq";
       public          postgres    false    249            J           0    0    tbUsuarios_id_usuario_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."tbUsuarios_id_usuario_seq" OWNED BY public."tbUsuarios".id_usuario;
          public          postgres    false    248                        2604    17760 !   tbAgenciaSeguro id_agencia_seguro    DEFAULT     �   ALTER TABLE ONLY public."tbAgenciaSeguro" ALTER COLUMN id_agencia_seguro SET DEFAULT nextval('public."tbAgenciaSeguro_id_agencia_seguro_seq"'::regclass);
 R   ALTER TABLE public."tbAgenciaSeguro" ALTER COLUMN id_agencia_seguro DROP DEFAULT;
       public          postgres    false    215    216    216            !           2604    17769 "   tbCliente numero_identidad_cliente    DEFAULT     �   ALTER TABLE ONLY public."tbCliente" ALTER COLUMN numero_identidad_cliente SET DEFAULT nextval('public."tbCliente_numero_identidad_cliente_seq"'::regclass);
 S   ALTER TABLE public."tbCliente" ALTER COLUMN numero_identidad_cliente DROP DEFAULT;
       public          postgres    false    217    218    218            "           2604    17778 )   tbCompReaseguradora id_comp_reaseguradora    DEFAULT     �   ALTER TABLE ONLY public."tbCompReaseguradora" ALTER COLUMN id_comp_reaseguradora SET DEFAULT nextval('public."tbCompReaseguradora_id_comp_reaseguradora_seq"'::regclass);
 Z   ALTER TABLE public."tbCompReaseguradora" ALTER COLUMN id_comp_reaseguradora DROP DEFAULT;
       public          postgres    false    219    220    220            #           2604    17785    tbEstadoPoliza id_estado_poliza    DEFAULT     �   ALTER TABLE ONLY public."tbEstadoPoliza" ALTER COLUMN id_estado_poliza SET DEFAULT nextval('public."tbEstadoPoliza_id_estado_poliza_seq"'::regclass);
 P   ALTER TABLE public."tbEstadoPoliza" ALTER COLUMN id_estado_poliza DROP DEFAULT;
       public          postgres    false    222    221    222            $           2604    17792 )   tbEstadoReclamacion id_estado_reclamacion    DEFAULT     �   ALTER TABLE ONLY public."tbEstadoReclamacion" ALTER COLUMN id_estado_reclamacion SET DEFAULT nextval('public."tbEstadoReclamacion_id_estado_reclamacion_seq"'::regclass);
 Z   ALTER TABLE public."tbEstadoReclamacion" ALTER COLUMN id_estado_reclamacion DROP DEFAULT;
       public          postgres    false    223    224    224            %           2604    17818    tbPais id_pais    DEFAULT     t   ALTER TABLE ONLY public."tbPais" ALTER COLUMN id_pais SET DEFAULT nextval('public."tbPais_id_pais_seq"'::regclass);
 ?   ALTER TABLE public."tbPais" ALTER COLUMN id_pais DROP DEFAULT;
       public          postgres    false    228    227    228            &           2604    17825    tbPoliza numero_poliza    DEFAULT     �   ALTER TABLE ONLY public."tbPoliza" ALTER COLUMN numero_poliza SET DEFAULT nextval('public."tbPoliza_numero_poliza_seq"'::regclass);
 G   ALTER TABLE public."tbPoliza" ALTER COLUMN numero_poliza DROP DEFAULT;
       public          postgres    false    229    230    230            '           2604    17832 (   tbPorcentParticipacion id_agencia_seguro    DEFAULT     �   ALTER TABLE ONLY public."tbPorcentParticipacion" ALTER COLUMN id_agencia_seguro SET DEFAULT nextval('public."tbPorcentParticipacion_id_agencia_seguro_seq"'::regclass);
 Y   ALTER TABLE public."tbPorcentParticipacion" ALTER COLUMN id_agencia_seguro DROP DEFAULT;
       public          postgres    false    232    231    232            (           2604    17839     tbReclamacion numero_reclamacion    DEFAULT     �   ALTER TABLE ONLY public."tbReclamacion" ALTER COLUMN numero_reclamacion SET DEFAULT nextval('public."tbReclamacion_numero_reclamacion_seq"'::regclass);
 Q   ALTER TABLE public."tbReclamacion" ALTER COLUMN numero_reclamacion DROP DEFAULT;
       public          postgres    false    233    234    234            /           2604    19456    tbRol id_rol    DEFAULT     p   ALTER TABLE ONLY public."tbRol" ALTER COLUMN id_rol SET DEFAULT nextval('public."tbRol_id_rol_seq"'::regclass);
 =   ALTER TABLE public."tbRol" ALTER COLUMN id_rol DROP DEFAULT;
       public          postgres    false    259    258    259            )           2604    17846    tbSexo id_sexo    DEFAULT     t   ALTER TABLE ONLY public."tbSexo" ALTER COLUMN id_sexo SET DEFAULT nextval('public."tbSexo_id_sexo_seq"'::regclass);
 ?   ALTER TABLE public."tbSexo" ALTER COLUMN id_sexo DROP DEFAULT;
       public          postgres    false    235    236    236            -           2604    17965 !   tbTipoCobertura id_tipo_cobertura    DEFAULT     �   ALTER TABLE ONLY public."tbTipoCobertura" ALTER COLUMN id_tipo_cobertura SET DEFAULT nextval('public."tbTipoCobertura_id_tipo_cobertura_seq"'::regclass);
 R   ALTER TABLE public."tbTipoCobertura" ALTER COLUMN id_tipo_cobertura DROP DEFAULT;
       public          postgres    false    243    244    244            *           2604    17855 !   tbTipoReaseguro id_tipo_reaseguro    DEFAULT     �   ALTER TABLE ONLY public."tbTipoReaseguro" ALTER COLUMN id_tipo_reaseguro SET DEFAULT nextval('public."tbTipoReaseguro_id_tipo_reaseguro_seq"'::regclass);
 R   ALTER TABLE public."tbTipoReaseguro" ALTER COLUMN id_tipo_reaseguro DROP DEFAULT;
       public          postgres    false    238    237    238            +           2604    17862    tbTipoSeguro id_tipo_seguro    DEFAULT     �   ALTER TABLE ONLY public."tbTipoSeguro" ALTER COLUMN id_tipo_seguro SET DEFAULT nextval('public."tbTipoSeguro_id_tipo_seguro_seq"'::regclass);
 L   ALTER TABLE public."tbTipoSeguro" ALTER COLUMN id_tipo_seguro DROP DEFAULT;
       public          postgres    false    240    239    240            ,           2604    17869 !   tbTipoSiniestro id_tipo_siniestro    DEFAULT     �   ALTER TABLE ONLY public."tbTipoSiniestro" ALTER COLUMN id_tipo_siniestro SET DEFAULT nextval('public."tbTipoSiniestro_id_tipo_siniestro_seq"'::regclass);
 R   ALTER TABLE public."tbTipoSiniestro" ALTER COLUMN id_tipo_siniestro DROP DEFAULT;
       public          postgres    false    241    242    242            .           2604    19370    tbUsuarios id_usuario    DEFAULT     �   ALTER TABLE ONLY public."tbUsuarios" ALTER COLUMN id_usuario SET DEFAULT nextval('public."tbUsuarios_id_usuario_seq"'::regclass);
 F   ALTER TABLE public."tbUsuarios" ALTER COLUMN id_usuario DROP DEFAULT;
       public          postgres    false    248    249    249                      0    17757    tbAgenciaSeguro 
   TABLE DATA           �   COPY public."tbAgenciaSeguro" (id_agencia_seguro, nombre_agencia_seguro, direccion_postal, telefono, correo_electronico, nombre_director_general, nombre_jefe_departamento_seguros, nombre_jefe_departamento_reclamaciones) FROM stdin;
    public          postgres    false    216   &                0    17766 	   tbCliente 
   TABLE DATA           �   COPY public."tbCliente" (numero_identidad_cliente, id_pais, id_sexo, nombre_cliente, apellido_cliente, edad, direccion_postal, telefono, correo_electronico, carnet_identidad) FROM stdin;
    public          postgres    false    218   �                0    17775    tbCompReaseguradora 
   TABLE DATA           �   COPY public."tbCompReaseguradora" (id_comp_reaseguradora, id_pais, id_tipo_reaseguro, nombre_compannia_reaseguradora) FROM stdin;
    public          postgres    false    220   
                0    17782    tbEstadoPoliza 
   TABLE DATA           R   COPY public."tbEstadoPoliza" (id_estado_poliza, nombre_estado_poliza) FROM stdin;
    public          postgres    false    222   d
                0    17789    tbEstadoReclamacion 
   TABLE DATA           a   COPY public."tbEstadoReclamacion" (id_estado_reclamacion, nombre_estado_reclamacion) FROM stdin;
    public          postgres    false    224   �
                0    17800    tbMotivoCancelacionPoliza 
   TABLE DATA           X   COPY public."tbMotivoCancelacionPoliza" (numero_poliza, descripcion_motivo) FROM stdin;
    public          postgres    false    225   �
                0    17805    tbMotivoRechazoReclamacion 
   TABLE DATA           Z   COPY public."tbMotivoRechazoReclamacion" (numero_reclamacion, motivo_rechazo) FROM stdin;
    public          postgres    false    226                   0    17815    tbPais 
   TABLE DATA           8   COPY public."tbPais" (id_pais, nombre_pais) FROM stdin;
    public          postgres    false    228   �                0    17822    tbPoliza 
   TABLE DATA           �   COPY public."tbPoliza" (numero_poliza, id_agencia_seguro, numero_identidad_cliente, id_estado_poliza, id_tipo_seguro, fecha_inicio, fecha_fin, prima_mensual, monto_total_asegurado, id_tipo_cobertura) FROM stdin;
    public          postgres    false    230   J      !          0    17829    tbPorcentParticipacion 
   TABLE DATA           �   COPY public."tbPorcentParticipacion" (id_agencia_seguro, id_tipo_seguro, id_comp_reaseguradora, porciento_participacion) FROM stdin;
    public          postgres    false    232   �      /          0    19340    tbPrimaMensual 
   TABLE DATA           R   COPY public."tbPrimaMensual" (numero_poliza, monto_pagado, mes, anno) FROM stdin;
    public          postgres    false    247         #          0    17836    tbReclamacion 
   TABLE DATA           �   COPY public."tbReclamacion" (numero_reclamacion, numero_poliza, id_estado_reclamacion, id_tipo_siniestro, fecha_siniestro, monto_reclamado, monto_indemnizado) FROM stdin;
    public          postgres    false    234   W      3          0    19453    tbRol 
   TABLE DATA           5   COPY public."tbRol" (id_rol, nombre_rol) FROM stdin;
    public          postgres    false    259   �      .          0    18163    tbSegurosDeAgencia 
   TABLE DATA           Q   COPY public."tbSegurosDeAgencia" (id_tipo_seguro, id_agencia_seguro) FROM stdin;
    public          postgres    false    246         %          0    17843    tbSexo 
   TABLE DATA           8   COPY public."tbSexo" (id_sexo, nombre_sexo) FROM stdin;
    public          postgres    false    236   (      -          0    17962    tbTipoCobertura 
   TABLE DATA           U   COPY public."tbTipoCobertura" (id_tipo_cobertura, nombre_tipo_cobertura) FROM stdin;
    public          postgres    false    244   Y      '          0    17852    tbTipoReaseguro 
   TABLE DATA           U   COPY public."tbTipoReaseguro" (id_tipo_reaseguro, nombre_tipo_reaseguro) FROM stdin;
    public          postgres    false    238   �      )          0    17859    tbTipoSeguro 
   TABLE DATA           L   COPY public."tbTipoSeguro" (id_tipo_seguro, nombre_tipo_seguro) FROM stdin;
    public          postgres    false    240   �      +          0    17866    tbTipoSiniestro 
   TABLE DATA           P   COPY public."tbTipoSiniestro" (id_tipo_siniestro, nombre_siniestro) FROM stdin;
    public          postgres    false    242         4          0    19459 	   tbUserRol 
   TABLE DATA           9   COPY public."tbUserRol" (id_usuario, id_rol) FROM stdin;
    public          postgres    false    260   x      1          0    19367 
   tbUsuarios 
   TABLE DATA           O   COPY public."tbUsuarios" (id_usuario, nombre_usuario, contrasenna) FROM stdin;
    public          postgres    false    249   �      K           0    0 %   tbAgenciaSeguro_id_agencia_seguro_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."tbAgenciaSeguro_id_agencia_seguro_seq"', 8, true);
          public          postgres    false    215            L           0    0 &   tbCliente_numero_identidad_cliente_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public."tbCliente_numero_identidad_cliente_seq"', 10, true);
          public          postgres    false    217            M           0    0 -   tbCompReaseguradora_id_comp_reaseguradora_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public."tbCompReaseguradora_id_comp_reaseguradora_seq"', 9, true);
          public          postgres    false    219            N           0    0 #   tbEstadoPoliza_id_estado_poliza_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."tbEstadoPoliza_id_estado_poliza_seq"', 3, true);
          public          postgres    false    221            O           0    0 -   tbEstadoReclamacion_id_estado_reclamacion_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public."tbEstadoReclamacion_id_estado_reclamacion_seq"', 3, true);
          public          postgres    false    223            P           0    0    tbPais_id_pais_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."tbPais_id_pais_seq"', 16, true);
          public          postgres    false    227            Q           0    0    tbPoliza_numero_poliza_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."tbPoliza_numero_poliza_seq"', 34, true);
          public          postgres    false    229            R           0    0 ,   tbPorcentParticipacion_id_agencia_seguro_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public."tbPorcentParticipacion_id_agencia_seguro_seq"', 1, false);
          public          postgres    false    231            S           0    0 $   tbReclamacion_numero_reclamacion_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."tbReclamacion_numero_reclamacion_seq"', 9, true);
          public          postgres    false    233            T           0    0    tbRol_id_rol_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."tbRol_id_rol_seq"', 2, true);
          public          postgres    false    258            U           0    0    tbSexo_id_sexo_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."tbSexo_id_sexo_seq"', 2, true);
          public          postgres    false    235            V           0    0 %   tbTipoCobertura_id_tipo_cobertura_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."tbTipoCobertura_id_tipo_cobertura_seq"', 9, true);
          public          postgres    false    243            W           0    0 %   tbTipoReaseguro_id_tipo_reaseguro_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."tbTipoReaseguro_id_tipo_reaseguro_seq"', 2, true);
          public          postgres    false    237            X           0    0    tbTipoSeguro_id_tipo_seguro_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."tbTipoSeguro_id_tipo_seguro_seq"', 6, true);
          public          postgres    false    239            Y           0    0 %   tbTipoSiniestro_id_tipo_siniestro_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."tbTipoSiniestro_id_tipo_siniestro_seq"', 8, true);
          public          postgres    false    241            Z           0    0    tbUsuarios_id_usuario_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."tbUsuarios_id_usuario_seq"', 3, true);
          public          postgres    false    248            1           2606    18133 J   tbAgenciaSeguro tbAgenciaSeguro_correo_electronico_correo_electronico1_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbAgenciaSeguro"
    ADD CONSTRAINT "tbAgenciaSeguro_correo_electronico_correo_electronico1_key" UNIQUE (correo_electronico) INCLUDE (correo_electronico);
 x   ALTER TABLE ONLY public."tbAgenciaSeguro" DROP CONSTRAINT "tbAgenciaSeguro_correo_electronico_correo_electronico1_key";
       public            postgres    false    216            3           2606    17764 $   tbAgenciaSeguro tbAgenciaSeguro_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."tbAgenciaSeguro"
    ADD CONSTRAINT "tbAgenciaSeguro_pkey" PRIMARY KEY (id_agencia_seguro);
 R   ALTER TABLE ONLY public."tbAgenciaSeguro" DROP CONSTRAINT "tbAgenciaSeguro_pkey";
       public            postgres    false    216            5           2606    18008 :   tbCliente tbCliente_carnet_identidad_carnet_identidad1_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "tbCliente_carnet_identidad_carnet_identidad1_key" UNIQUE (carnet_identidad) INCLUDE (carnet_identidad);
 h   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "tbCliente_carnet_identidad_carnet_identidad1_key";
       public            postgres    false    218            7           2606    18012 >   tbCliente tbCliente_correo_electronico_correo_electronico1_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "tbCliente_correo_electronico_correo_electronico1_key" UNIQUE (correo_electronico) INCLUDE (correo_electronico);
 l   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "tbCliente_correo_electronico_correo_electronico1_key";
       public            postgres    false    218            9           2606    17773    tbCliente tbCliente_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "tbCliente_pkey" PRIMARY KEY (numero_identidad_cliente);
 F   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "tbCliente_pkey";
       public            postgres    false    218            ;           2606    17780 ,   tbCompReaseguradora tbCompReaseguradora_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbCompReaseguradora"
    ADD CONSTRAINT "tbCompReaseguradora_pkey" PRIMARY KEY (id_comp_reaseguradora);
 Z   ALTER TABLE ONLY public."tbCompReaseguradora" DROP CONSTRAINT "tbCompReaseguradora_pkey";
       public            postgres    false    220            =           2606    17787 "   tbEstadoPoliza tbEstadoPoliza_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."tbEstadoPoliza"
    ADD CONSTRAINT "tbEstadoPoliza_pkey" PRIMARY KEY (id_estado_poliza);
 P   ALTER TABLE ONLY public."tbEstadoPoliza" DROP CONSTRAINT "tbEstadoPoliza_pkey";
       public            postgres    false    222            ?           2606    17794 ,   tbEstadoReclamacion tbEstadoReclamacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbEstadoReclamacion"
    ADD CONSTRAINT "tbEstadoReclamacion_pkey" PRIMARY KEY (id_estado_reclamacion);
 Z   ALTER TABLE ONLY public."tbEstadoReclamacion" DROP CONSTRAINT "tbEstadoReclamacion_pkey";
       public            postgres    false    224            A           2606    17804 4   tbMotivoCancelacionPoliza tbMotivoRechazoPoliza_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbMotivoCancelacionPoliza"
    ADD CONSTRAINT "tbMotivoRechazoPoliza_pkey" PRIMARY KEY (numero_poliza);
 b   ALTER TABLE ONLY public."tbMotivoCancelacionPoliza" DROP CONSTRAINT "tbMotivoRechazoPoliza_pkey";
       public            postgres    false    225            C           2606    17811 :   tbMotivoRechazoReclamacion tbMotivoRechazoReclamacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbMotivoRechazoReclamacion"
    ADD CONSTRAINT "tbMotivoRechazoReclamacion_pkey" PRIMARY KEY (numero_reclamacion);
 h   ALTER TABLE ONLY public."tbMotivoRechazoReclamacion" DROP CONSTRAINT "tbMotivoRechazoReclamacion_pkey";
       public            postgres    false    226            E           2606    17998 *   tbPais tbPais_nombre_pais_nombre_pais1_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbPais"
    ADD CONSTRAINT "tbPais_nombre_pais_nombre_pais1_key" UNIQUE (nombre_pais) INCLUDE (nombre_pais);
 X   ALTER TABLE ONLY public."tbPais" DROP CONSTRAINT "tbPais_nombre_pais_nombre_pais1_key";
       public            postgres    false    228            G           2606    17820    tbPais tbPais_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."tbPais"
    ADD CONSTRAINT "tbPais_pkey" PRIMARY KEY (id_pais);
 @   ALTER TABLE ONLY public."tbPais" DROP CONSTRAINT "tbPais_pkey";
       public            postgres    false    228            I           2606    17827    tbPoliza tbPoliza_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "tbPoliza_pkey" PRIMARY KEY (numero_poliza);
 D   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "tbPoliza_pkey";
       public            postgres    false    230            K           2606    17834 2   tbPorcentParticipacion tbPorcentParticipacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbPorcentParticipacion"
    ADD CONSTRAINT "tbPorcentParticipacion_pkey" PRIMARY KEY (id_agencia_seguro, id_tipo_seguro, id_comp_reaseguradora);
 `   ALTER TABLE ONLY public."tbPorcentParticipacion" DROP CONSTRAINT "tbPorcentParticipacion_pkey";
       public            postgres    false    232    232    232            [           2606    19344 "   tbPrimaMensual tbPrimaMensual_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."tbPrimaMensual"
    ADD CONSTRAINT "tbPrimaMensual_pkey" PRIMARY KEY (anno, mes, numero_poliza);
 P   ALTER TABLE ONLY public."tbPrimaMensual" DROP CONSTRAINT "tbPrimaMensual_pkey";
       public            postgres    false    247    247    247            M           2606    17841     tbReclamacion tbReclamacion_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."tbReclamacion"
    ADD CONSTRAINT "tbReclamacion_pkey" PRIMARY KEY (numero_reclamacion);
 N   ALTER TABLE ONLY public."tbReclamacion" DROP CONSTRAINT "tbReclamacion_pkey";
       public            postgres    false    234            _           2606    19458    tbRol tbRol_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public."tbRol"
    ADD CONSTRAINT "tbRol_pkey" PRIMARY KEY (id_rol);
 >   ALTER TABLE ONLY public."tbRol" DROP CONSTRAINT "tbRol_pkey";
       public            postgres    false    259            Y           2606    18167 *   tbSegurosDeAgencia tbSegurosDeAgencia_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbSegurosDeAgencia"
    ADD CONSTRAINT "tbSegurosDeAgencia_pkey" PRIMARY KEY (id_tipo_seguro, id_agencia_seguro);
 X   ALTER TABLE ONLY public."tbSegurosDeAgencia" DROP CONSTRAINT "tbSegurosDeAgencia_pkey";
       public            postgres    false    246    246            O           2606    17850    tbSexo tbSexo_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."tbSexo"
    ADD CONSTRAINT "tbSexo_pkey" PRIMARY KEY (id_sexo);
 @   ALTER TABLE ONLY public."tbSexo" DROP CONSTRAINT "tbSexo_pkey";
       public            postgres    false    236            W           2606    17969 $   tbTipoCobertura tbTipoCobertura_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."tbTipoCobertura"
    ADD CONSTRAINT "tbTipoCobertura_pkey" PRIMARY KEY (id_tipo_cobertura);
 R   ALTER TABLE ONLY public."tbTipoCobertura" DROP CONSTRAINT "tbTipoCobertura_pkey";
       public            postgres    false    244            Q           2606    17857 $   tbTipoReaseguro tbTipoReaseguro_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."tbTipoReaseguro"
    ADD CONSTRAINT "tbTipoReaseguro_pkey" PRIMARY KEY (id_tipo_reaseguro);
 R   ALTER TABLE ONLY public."tbTipoReaseguro" DROP CONSTRAINT "tbTipoReaseguro_pkey";
       public            postgres    false    238            S           2606    17864    tbTipoSeguro tbTipoSeguro_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."tbTipoSeguro"
    ADD CONSTRAINT "tbTipoSeguro_pkey" PRIMARY KEY (id_tipo_seguro);
 L   ALTER TABLE ONLY public."tbTipoSeguro" DROP CONSTRAINT "tbTipoSeguro_pkey";
       public            postgres    false    240            U           2606    17871 $   tbTipoSiniestro tbTipoSiniestro_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."tbTipoSiniestro"
    ADD CONSTRAINT "tbTipoSiniestro_pkey" PRIMARY KEY (id_tipo_siniestro);
 R   ALTER TABLE ONLY public."tbTipoSiniestro" DROP CONSTRAINT "tbTipoSiniestro_pkey";
       public            postgres    false    242            a           2606    19463    tbUserRol tbUserRol_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."tbUserRol"
    ADD CONSTRAINT "tbUserRol_pkey" PRIMARY KEY (id_usuario, id_rol);
 F   ALTER TABLE ONLY public."tbUserRol" DROP CONSTRAINT "tbUserRol_pkey";
       public            postgres    false    260    260            ]           2606    19374    tbUsuarios tbUsuarios_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."tbUsuarios"
    ADD CONSTRAINT "tbUsuarios_pkey" PRIMARY KEY (id_usuario);
 H   ALTER TABLE ONLY public."tbUsuarios" DROP CONSTRAINT "tbUsuarios_pkey";
       public            postgres    false    249                       2618    19387 9   salida_cliente_con_cantidad_reclamacion_rechazada _RETURN    RULE       CREATE OR REPLACE VIEW public.salida_cliente_con_cantidad_reclamacion_rechazada AS
 SELECT "tbCliente".nombre_cliente,
    "tbCliente".numero_identidad_cliente,
    count("tbReclamacion".numero_reclamacion) AS count
   FROM public."tbReclamacion",
    public."tbPoliza",
    public."tbCliente"
  WHERE (("tbPoliza".numero_poliza = "tbReclamacion".numero_poliza) AND ("tbReclamacion".id_estado_reclamacion = 3) AND ("tbPoliza".numero_identidad_cliente = "tbCliente".numero_identidad_cliente))
  GROUP BY "tbCliente".numero_identidad_cliente;
 �   CREATE OR REPLACE VIEW public.salida_cliente_con_cantidad_reclamacion_rechazada AS
SELECT
    NULL::character varying(50) AS nombre_cliente,
    NULL::integer AS numero_identidad_cliente,
    NULL::bigint AS count;
       public          postgres    false    230    234    230    234    234    218    4921    218    250            	           2618    19396 8   salida_cliente_con_cantidad_reclamacion_aprobada _RETURN    RULE     O  CREATE OR REPLACE VIEW public.salida_cliente_con_cantidad_reclamacion_aprobada AS
 SELECT "tbCliente".nombre_cliente,
    "tbCliente".numero_identidad_cliente,
    count("tbReclamacion".numero_reclamacion) AS count,
    sum("tbReclamacion".monto_indemnizado) AS sum
   FROM public."tbReclamacion",
    public."tbPoliza",
    public."tbCliente"
  WHERE (("tbPoliza".numero_poliza = "tbReclamacion".numero_poliza) AND ("tbReclamacion".id_estado_reclamacion = 1) AND ("tbPoliza".numero_identidad_cliente = "tbCliente".numero_identidad_cliente))
  GROUP BY "tbCliente".numero_identidad_cliente;
 �   CREATE OR REPLACE VIEW public.salida_cliente_con_cantidad_reclamacion_aprobada AS
SELECT
    NULL::character varying(50) AS nombre_cliente,
    NULL::integer AS numero_identidad_cliente,
    NULL::bigint AS count,
    NULL::double precision AS sum;
       public          postgres    false    4921    234    234    234    230    230    218    218    234    251            h           2606    18178    tbPoliza Cobertura_Poliza    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Cobertura_Poliza" FOREIGN KEY (id_tipo_cobertura) REFERENCES public."tbTipoCobertura"(id_tipo_cobertura) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Cobertura_Poliza";
       public          postgres    false    230    4951    244            i           2606    18063    tbPoliza Estado_Poliza    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Estado_Poliza" FOREIGN KEY (id_estado_poliza) REFERENCES public."tbEstadoPoliza"(id_estado_poliza) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 D   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Estado_Poliza";
       public          postgres    false    222    4925    230            p           2606    18108     tbReclamacion Estado_Reclamacion    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbReclamacion"
    ADD CONSTRAINT "Estado_Reclamacion" FOREIGN KEY (id_estado_reclamacion) REFERENCES public."tbEstadoReclamacion"(id_estado_reclamacion) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public."tbReclamacion" DROP CONSTRAINT "Estado_Reclamacion";
       public          postgres    false    234    4927    224            m           2606    18083 "   tbPorcentParticipacion PP_AgenciaS    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPorcentParticipacion"
    ADD CONSTRAINT "PP_AgenciaS" FOREIGN KEY (id_agencia_seguro) REFERENCES public."tbAgenciaSeguro"(id_agencia_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."tbPorcentParticipacion" DROP CONSTRAINT "PP_AgenciaS";
       public          postgres    false    232    216    4915            n           2606    18093    tbPorcentParticipacion PP_CompR    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPorcentParticipacion"
    ADD CONSTRAINT "PP_CompR" FOREIGN KEY (id_comp_reaseguradora) REFERENCES public."tbCompReaseguradora"(id_comp_reaseguradora) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 M   ALTER TABLE ONLY public."tbPorcentParticipacion" DROP CONSTRAINT "PP_CompR";
       public          postgres    false    4923    232    220            o           2606    18088    tbPorcentParticipacion PP_TipoS    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPorcentParticipacion"
    ADD CONSTRAINT "PP_TipoS" FOREIGN KEY (id_tipo_seguro) REFERENCES public."tbTipoSeguro"(id_tipo_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 M   ALTER TABLE ONLY public."tbPorcentParticipacion" DROP CONSTRAINT "PP_TipoS";
       public          postgres    false    4947    240    232            j           2606    18068    tbPoliza Poliza_AgenciaS    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Poliza_AgenciaS" FOREIGN KEY (id_agencia_seguro) REFERENCES public."tbAgenciaSeguro"(id_agencia_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Poliza_AgenciaS";
       public          postgres    false    216    230    4915            f           2606    18053 *   tbMotivoCancelacionPoliza Poliza_Cancelada    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbMotivoCancelacionPoliza"
    ADD CONSTRAINT "Poliza_Cancelada" FOREIGN KEY (numero_poliza) REFERENCES public."tbPoliza"(numero_poliza) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 X   ALTER TABLE ONLY public."tbMotivoCancelacionPoliza" DROP CONSTRAINT "Poliza_Cancelada";
       public          postgres    false    225    4937    230            k           2606    18073    tbPoliza Poliza_Cliente    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Poliza_Cliente" FOREIGN KEY (numero_identidad_cliente) REFERENCES public."tbCliente"(numero_identidad_cliente) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 E   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Poliza_Cliente";
       public          postgres    false    230    4921    218            l           2606    18078    tbPoliza Poliza_TipoSeguro    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Poliza_TipoSeguro" FOREIGN KEY (id_tipo_seguro) REFERENCES public."tbTipoSeguro"(id_tipo_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 H   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Poliza_TipoSeguro";
       public          postgres    false    230    240    4947            b           2606    18028    tbCliente Procedencia_Cliente    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "Procedencia_Cliente" FOREIGN KEY (id_pais) REFERENCES public."tbPais"(id_pais) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 K   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "Procedencia_Cliente";
       public          postgres    false    4935    218    228            d           2606    18043 %   tbCompReaseguradora Procedencia_CompR    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbCompReaseguradora"
    ADD CONSTRAINT "Procedencia_CompR" FOREIGN KEY (id_pais) REFERENCES public."tbPais"(id_pais) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 S   ALTER TABLE ONLY public."tbCompReaseguradora" DROP CONSTRAINT "Procedencia_CompR";
       public          postgres    false    220    4935    228            q           2606    18098     tbReclamacion Reclamacion_Poliza    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbReclamacion"
    ADD CONSTRAINT "Reclamacion_Poliza" FOREIGN KEY (numero_poliza) REFERENCES public."tbPoliza"(numero_poliza) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public."tbReclamacion" DROP CONSTRAINT "Reclamacion_Poliza";
       public          postgres    false    4937    234    230            g           2606    18058 0   tbMotivoRechazoReclamacion Reclamacion_Rechazada    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbMotivoRechazoReclamacion"
    ADD CONSTRAINT "Reclamacion_Rechazada" FOREIGN KEY (numero_reclamacion) REFERENCES public."tbReclamacion"(numero_reclamacion) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 ^   ALTER TABLE ONLY public."tbMotivoRechazoReclamacion" DROP CONSTRAINT "Reclamacion_Rechazada";
       public          postgres    false    4941    226    234            r           2606    18103 $   tbReclamacion Reclamacion_TSiniestro    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbReclamacion"
    ADD CONSTRAINT "Reclamacion_TSiniestro" FOREIGN KEY (id_tipo_siniestro) REFERENCES public."tbTipoSiniestro"(id_tipo_siniestro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 R   ALTER TABLE ONLY public."tbReclamacion" DROP CONSTRAINT "Reclamacion_TSiniestro";
       public          postgres    false    234    4949    242            c           2606    18023    tbCliente Sexo_Cliente    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "Sexo_Cliente" FOREIGN KEY (id_sexo) REFERENCES public."tbSexo"(id_sexo) ON UPDATE SET NULL ON DELETE SET NULL NOT VALID;
 D   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "Sexo_Cliente";
       public          postgres    false    218    4943    236            e           2606    18048 '   tbCompReaseguradora TipoReaseguro_CompR    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbCompReaseguradora"
    ADD CONSTRAINT "TipoReaseguro_CompR" FOREIGN KEY (id_tipo_reaseguro) REFERENCES public."tbTipoReaseguro"(id_tipo_reaseguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 U   ALTER TABLE ONLY public."tbCompReaseguradora" DROP CONSTRAINT "TipoReaseguro_CompR";
       public          postgres    false    4945    238    220            u           2606    19345 0   tbPrimaMensual tbPrimaMensual_numero_poliza_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPrimaMensual"
    ADD CONSTRAINT "tbPrimaMensual_numero_poliza_fkey" FOREIGN KEY (numero_poliza) REFERENCES public."tbPoliza"(numero_poliza) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 ^   ALTER TABLE ONLY public."tbPrimaMensual" DROP CONSTRAINT "tbPrimaMensual_numero_poliza_fkey";
       public          postgres    false    230    4937    247            s           2606    18173 <   tbSegurosDeAgencia tbSegurosDeAgencia_id_agencia_seguro_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbSegurosDeAgencia"
    ADD CONSTRAINT "tbSegurosDeAgencia_id_agencia_seguro_fkey" FOREIGN KEY (id_agencia_seguro) REFERENCES public."tbAgenciaSeguro"(id_agencia_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 j   ALTER TABLE ONLY public."tbSegurosDeAgencia" DROP CONSTRAINT "tbSegurosDeAgencia_id_agencia_seguro_fkey";
       public          postgres    false    4915    246    216            t           2606    18168 9   tbSegurosDeAgencia tbSegurosDeAgencia_id_tipo_seguro_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbSegurosDeAgencia"
    ADD CONSTRAINT "tbSegurosDeAgencia_id_tipo_seguro_fkey" FOREIGN KEY (id_tipo_seguro) REFERENCES public."tbTipoSeguro"(id_tipo_seguro) ON UPDATE CASCADE ON DELETE CASCADE;
 g   ALTER TABLE ONLY public."tbSegurosDeAgencia" DROP CONSTRAINT "tbSegurosDeAgencia_id_tipo_seguro_fkey";
       public          postgres    false    246    240    4947            v           2606    19469    tbUserRol tbUserRol_id_rol_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbUserRol"
    ADD CONSTRAINT "tbUserRol_id_rol_fkey" FOREIGN KEY (id_rol) REFERENCES public."tbRol"(id_rol) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 M   ALTER TABLE ONLY public."tbUserRol" DROP CONSTRAINT "tbUserRol_id_rol_fkey";
       public          postgres    false    4959    259    260            w           2606    19464 #   tbUserRol tbUserRol_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbUserRol"
    ADD CONSTRAINT "tbUserRol_id_usuario_fkey" FOREIGN KEY (id_usuario) REFERENCES public."tbUsuarios"(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 Q   ALTER TABLE ONLY public."tbUserRol" DROP CONSTRAINT "tbUserRol_id_usuario_fkey";
       public          postgres    false    260    249    4957               �  x�u��n�0���S�	�̱�V#�6K$�N��1c��B��&O?.�Q�`@0�S�ǟ�u��`����F<��ҙ�@�2fsd=c��3Ve:�E�X��<�e@������W�k;26=Hk	��}e����{~���u�
�.�3���]�r�E	��#��
�,�sH�x�xCN���Y��Ȟg�6qƬH�Vm�墬f�*/�>ҌY�$�&T�d�^:�ڞ/�����*���aG6��Ə���?�ސ#����>q�զ�>�ꊶ����"�N�XN��yB���8�����6����w�����C�Q����ޢ�%Ԯe��u��B����=�嘕���a��#�ыS������N^uU��3��I	?�Bs�8��&I���         E  x�e��N�0Eד��@Q�G��Z(,�v�ʒ�(��%�.N��~=��. yi�9��(�`�][߶.�	��'
��1eO��nSH�x����2�+=���bp��tml����@=͸�GO>�m�a%�6��R�B��K��c����͗Ó�:���UJʺ�7�i
�LwO�4�yx�O"X"��*�S&�}:�+T��fэ������tG+� ��.����,�j�48PL��	^\敀��Λ�H\a��\�Ѫ�F2�߄Ԧߡ�T�4�(��)[O��8Q��ڂfǎ�Dx��J<����e�-��u�2��P�ҟ���,��z���         ?   x�3�4�4��-�)�NMWp��-H̫�2�4J�&���%��%*x��yɩ\1z\\\ �uN         *   x�3�tN�KN�ILI�2�K�K���9�K2��b���� �V	�         .   x�3�t,(�OJLI�2�t�(�ON-��2�JM�H����qqq ���             x�34�t�IL#.CΌ��̌L�=... t��         �   x�UN;N1�'�x'X	��ȶ4��ge���N(8=��B�,���޶;�Zn��k18��6��a=�r%ʘ�}9���ʎ���*�(��,;B���.�>�&u~Bn'G��=�aX���~,7���ݯg@�&���T���lQɂɎu�d�a~U�+5ҿ�l�}�7�a��VJ�d�\�         m   x��1�0��W�'��X����B,r�ܡ8�?�ڑf6 �ǗQ�-���>�b���W�MMx�9o2y��M�ǭ��
��51�<���<t��T��{s>�$Ku L         z   x�=��	1��^|ȏl�^��:Nf!6"��6|Dm ���|�'�I8)a��G��Q�Rl^�=��H��Sw����Ba�56.^�e;����;�Ύ�P���-maS=�Lޟ����#r      !   (   x�3�4�4�44�S�F�\�@� EL�"&f\1z\\\ l�(      /   ;   x�=���0Cѳ=Le'�.�?GU@9�/�	KH�tҟ�u�Ƥ����V���3H.K�      #   j   x�M��1D�s��\�l�8�8�Y|�W��A����B�v(oa=��d;^���/�VEAOtQQvT?�K4�S\4�w3�_1s�Y����ԣvȾ3;Q�	      3       x�3�,K�KIM�/�2�LL�������� [��      .      x�3�4�2�4�2�=... 5      %   !   x�3�tK�M�����2��M,N.��c���� |�      -   (   x�3���2�(J��,��2�t-.I�KI,����� ��x      '   "   x�3���(�/�/J���K��2�D���qqq ��      )   1   x�3�t,-��2���OO,�2��LI�2�N�)M�2r�R�b���� �$
�      +   d   x�M�;1���9�:�p�m��!���q8?���^n�I�X��(W�L���$�I� ��Vك)ϰ�>mm#Z1���=e:��k��h)��/�#�      4      x������ � �      1   %   x�3��OO-�4 .#N��Ң|NC#c�=... x��     