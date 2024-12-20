PGDMP  ,                    |            PolSeg    16.2    16.4 �    4           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            5           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            6           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            7           1262    17799    PolSeg    DATABASE     �   CREATE DATABASE "PolSeg" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_United States.1252';
    DROP DATABASE "PolSeg";
                postgres    false            B           1255    17800    obtener_agencia_dadoid(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_agencia_dadoid(p_id_agencia_seguro integer) RETURNS TABLE(id_agencia_seguro integer, nombre_agencia_seguro character varying, direccion_postal character varying, telefono character varying, correo_electronico character varying, nombre_director_general character varying, nombre_jefe_departamento_seguros character varying, nombre_jefe_departamento_reclamaciones character varying)
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
       public          postgres    false            :           1255    17801    obtener_cliente_dadoid(integer)    FUNCTION     y  CREATE FUNCTION public.obtener_cliente_dadoid(p_numero_identidad_cliente integer) RETURNS TABLE(nombre_cliente character varying, numero_identidad_cliente integer, telefono character varying, direccion_postal character varying, correo_electronico character varying)
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
       public          postgres    false                       1255    17802    obtener_compre_dadoid(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_compre_dadoid(p_id_areaseguradora integer) RETURNS TABLE(nombre_compannia_reaseguradora character varying, nombre_pais character varying, nombre_tipo_reaseguro character varying)
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
       public          postgres    false            b           1255    17803 A   obtener_ingresos_mensuales_por_concepto_primas_dado_anno(integer)    FUNCTION     J  CREATE FUNCTION public.obtener_ingresos_mensuales_por_concepto_primas_dado_anno(p_anno integer) RETURNS TABLE(anno integer, mes integer, monto_pagado double precision)
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
       public          postgres    false            Y           1255    17804 5   obtener_polizas_activas_cantidad_dadocliente(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_polizas_activas_cantidad_dadocliente(p_numero_identidad_cliente integer) RETURNS TABLE(numero_poliza integer, contador integer)
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
       public          postgres    false            W           1255    17805 8   obtener_polizas_emitidas_dado_periodo_tiempo(date, date)    FUNCTION     G  CREATE FUNCTION public.obtener_polizas_emitidas_dado_periodo_tiempo(p_fecha_inicio date, p_fecha_fin date) RETURNS TABLE(numero_poliza integer, nombre_cliente character varying, nombre_tipo_seguro character varying, fecha_incio date, fecha_fin date, prima_mensual double precision, nombre_estado_poliza character varying)
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
       public          postgres    false            !           1255    17806 =   obtener_pparticipacion_dado_idagen_idcompre(integer, integer)    FUNCTION     �  CREATE FUNCTION public.obtener_pparticipacion_dado_idagen_idcompre(p_id_comp_reaseguradora integer, p_id_agencia integer) RETURNS TABLE(nombre_tipo_seguro character varying, porciento_participacion double precision)
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
       public          postgres    false            [           1255    17807 ,   obtener_reclamaciones_dado_polizaid(integer)    FUNCTION       CREATE FUNCTION public.obtener_reclamaciones_dado_polizaid(p_numero_poliza integer) RETURNS TABLE(numero_reclamacion integer, numero_poliza integer, id_estado_reclamacion integer, id_tipo_siniestro integer, fecha_siniestro date, monto_reclamado double precision, monto_indemnizado double precision)
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
       public          postgres    false            2           1255    17808 /   obtener_valor_total_primas_dado_poliza(integer)    FUNCTION     ]  CREATE FUNCTION public.obtener_valor_total_primas_dado_poliza(p_numero_poliza integer) RETURNS double precision
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
       public          postgres    false            4           1255    17809 *   roger_obtener_poliza_dado_cliente(integer)    FUNCTION     =  CREATE FUNCTION public.roger_obtener_poliza_dado_cliente(p_id_cliente integer) RETURNS TABLE(numero_poliza integer, nombre_agencia_seguro character varying, nombre_estado_poliza character varying, nombre_tipo_seguro character varying, fecha_inicio date, fecha_fin date, prima_mensual double precision, monto_total_asegurado double precision, nombre_tipo_cobertura character varying)
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
       public          postgres    false                       1255    17810 *   salida_motivo_rechazo_reclamacion(integer)    FUNCTION     Y  CREATE FUNCTION public.salida_motivo_rechazo_reclamacion(p_numero_identidad_cliente integer) RETURNS TABLE(motivo_rechazo text)
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
       public          postgres    false            @           1255    17811 .   salida_obtener_poliza_dado_tiposeguro(integer)    FUNCTION     B  CREATE FUNCTION public.salida_obtener_poliza_dado_tiposeguro(p_id_tipo_seguro integer) RETURNS TABLE(numero_poliza integer, numero_identidad_cliente integer, fecha_inicio date, fecha_fin date, prima_mensual double precision, monto_total_asegurado double precision, nombre_estado_poliza character varying)
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
       public          postgres    false            -           1255    17812 '   salida_polizas_activas_cliente(integer)    FUNCTION     �  CREATE FUNCTION public.salida_polizas_activas_cliente(p_id_pais integer) RETURNS TABLE(nombre_cliente character varying, numero_identidad_cliente integer, id_estado_poliza bigint)
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
       public          postgres    false                       1255    17813 9   salida_porciento_participacion_dado_id_compannia(integer)    FUNCTION     �  CREATE FUNCTION public.salida_porciento_participacion_dado_id_compannia(p_id_comp_reaseguradora integer) RETURNS TABLE(nombre_tipo_seguro character varying, porciento_participacion double precision)
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
       public          postgres    false            /           1255    17814 *   salida_total_monto_pagado_cliente(integer)    FUNCTION       CREATE FUNCTION public.salida_total_monto_pagado_cliente(p_id_pais integer) RETURNS TABLE(nombre_cliente character varying, numero_identidad_cliente integer, monto_pagado double precision)
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
       public          postgres    false            d           1255    17815    tbagenciaseguro_delete(integer)    FUNCTION     I  CREATE FUNCTION public.tbagenciaseguro_delete(p_id_agencia_seguro integer) RETURNS boolean
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
       public          postgres    false            i           1255    17816 �   tbagenciaseguro_insert(character varying, character varying, character varying, character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.tbagenciaseguro_insert(p_nombre_agencia_seguro character varying, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_nombre_director_general character varying, p_nombre_jefe_departamento_seguros character varying, p_nombre_jefe_departamento_reclamaciones character varying) RETURNS TABLE(id_agencia_seguro integer, nombre_agencia_seguro character varying, direccion_postal character varying, telefono character varying, correo_electronico character varying, nombre_director_general character varying, nombre_jefe_departamento_seguros character varying, nombre_jefe_departamento_reclamaciones character varying)
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
       public          postgres    false            ^           1255    17817    tbagenciaseguro_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbagenciaseguro_read(p_id_agencia_seguro integer) RETURNS TABLE(id_agencia_seguro integer, nombre_agencia_seguro character varying, direccion_postal character varying, telefono character varying, correo_electronico character varying, nombre_director_general character varying, nombre_jefe_departamento_seguros character varying, nombre_jefe_departamento_reclamaciones character varying)
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
       public          postgres    false            3           1255    18170    tbagenciaseguro_read_all()    FUNCTION     m  CREATE FUNCTION public.tbagenciaseguro_read_all() RETURNS TABLE(id_agencia_seguro integer, nombre_agencia_seguro character varying, direccion_postal character varying, telefono character varying, correo_electronico character varying, nombre_director_general character varying, nombre_jefe_departamento_seguros character varying, nombre_jefe_departamento_reclamaciones character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		RETURN QUERY
		SELECT public."tbAgenciaSeguro".id_agencia_seguro,public."tbAgenciaSeguro".nombre_agencia_seguro, public."tbAgenciaSeguro".direccion_postal, public."tbAgenciaSeguro".telefono, public."tbAgenciaSeguro".correo_electronico, public."tbAgenciaSeguro".nombre_director_general, public."tbAgenciaSeguro".nombre_jefe_departamento_seguros, public."tbAgenciaSeguro".nombre_jefe_departamento_reclamaciones
		FROM public."tbAgenciaSeguro";
END;
$$;
 1   DROP FUNCTION public.tbagenciaseguro_read_all();
       public          postgres    false            	           1255    17818 �   tbagenciaseguro_update(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.tbagenciaseguro_update(p_id_agencia_seguro integer, p_nombre_agencia_seguro character varying, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_nombre_director_general character varying, p_nombre_jefe_departamento_seguros character varying, p_nombre_jefe_departamento_reclamaciones character varying) RETURNS TABLE(id_agencia_seguro integer, nombre_agencia_seguro character varying, direccion_postal character varying, telefono character varying, correo_electronico character varying, nombre_director_general character varying, nombre_jefe_departamento_seguros character varying, nombre_jefe_departamento_reclamaciones character varying)
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
       public          postgres    false            _           1255    17819    tbcliente_delete(integer)    FUNCTION     O  CREATE FUNCTION public.tbcliente_delete(p_numero_identidad_cliente integer) RETURNS boolean
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
       public          postgres    false            F           1255    18205 �   tbcliente_insert(integer, integer, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.tbcliente_insert(p_numero_identidad_cliente integer, p_id_pais integer, p_id_sexo integer, p_nombre_cliente character varying, p_apellido_cliente character varying, p_edad integer, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_carnet_identidad character varying) RETURNS TABLE(numero_identidad_cliente integer, id_pais integer, id_sexo integer, nombre_cliente character varying, apellido_cliente character varying, edad integer, direccion_postal character varying, telefono character varying, correo_electronico character varying, carnet_identidad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbCliente" (numero_identidad_cliente,id_pais, id_sexo , 
			  nombre_cliente , apellido_cliente , edad , direccion_postal , telefono, 
			  correo_electronico , carnet_identidad) VALUES (p_numero_identidad_cliente,p_id_pais, p_id_sexo , 
											p_nombre_cliente, p_apellido_cliente ,
										   p_edad , p_direccion_postal , 
											p_telefono , p_correo_electronico,
											p_carnet_identidad);
		RETURN QUERY
		SELECT *
		FROM public."tbCliente";
END;
$$;
 ]  DROP FUNCTION public.tbcliente_insert(p_numero_identidad_cliente integer, p_id_pais integer, p_id_sexo integer, p_nombre_cliente character varying, p_apellido_cliente character varying, p_edad integer, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_carnet_identidad character varying);
       public          postgres    false            g           1255    17821    tbcliente_read(integer)    FUNCTION     .  CREATE FUNCTION public.tbcliente_read(p_numero_identidad_cliente integer) RETURNS TABLE(numero_identidad_cliente integer, id_pais integer, id_sexo integer, nombre_cliente character varying, apellido_cliente character varying, edad integer, direccion_postal character varying, telefono character varying, correo_electronico character varying, carnet_identidad character varying)
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
       public          postgres    false            "           1255    18169    tbcliente_read_all()    FUNCTION     �  CREATE FUNCTION public.tbcliente_read_all() RETURNS TABLE(numero_identidad_cliente integer, id_pais integer, id_sexo integer, nombre_cliente character varying, apellido_cliente character varying, edad integer, direccion_postal character varying, telefono character varying, correo_electronico character varying, carnet_identidad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		RETURN QUERY
		SELECT *
		FROM public."tbCliente";
END;
$$;
 +   DROP FUNCTION public.tbcliente_read_all();
       public          postgres    false            *           1255    17822 �   tbcliente_update(integer, integer, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.tbcliente_update(p_numero_identidad_cliente integer, p_id_pais integer, p_id_sexo integer, p_nombre_cliente character varying, p_apellido_cliente character varying, p_edad integer, p_direccion_postal character varying, p_telefono character varying, p_correo_electronico character varying, p_carnet_identidad character varying) RETURNS TABLE(numero_identidad_cliente integer, id_pais integer, id_sexo integer, nombre_cliente character varying, apellido_cliente character varying, edad integer, direccion_postal character varying, telefono character varying, correo_electronico character varying, carnet_identidad character varying)
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
       public          postgres    false                       1255    17823 #   tbcompreaseguradora_delete(integer)    FUNCTION     c  CREATE FUNCTION public.tbcompreaseguradora_delete(p_id_comp_reaseguradora integer) RETURNS boolean
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
       public          postgres    false                       1255    17824 ?   tbcompreaseguradora_insert(integer, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbcompreaseguradora_insert(p_id_pais integer, p_id_tipo_reaseguro integer, p_nombre_compannia_reaseguradora character varying) RETURNS TABLE(id_comp_reaseguradora integer, id_pais integer, id_tipo_reaseguro integer, nombre_compannia_reaseguradora character varying)
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
       public          postgres    false            7           1255    18200    tbcompreaseguradora_read()    FUNCTION       CREATE FUNCTION public.tbcompreaseguradora_read() RETURNS TABLE(id_comp_reaseguradora integer, id_pais integer, id_tipo_reaseguro integer, nombre_compannia_reaseguradora character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		RETURN QUERY
		SELECT public."tbCompReaseguradora".id_comp_reaseguradora,
			   public."tbCompReaseguradora".id_pais , 
			   public."tbCompReaseguradora".id_tipo_reaseguro , 
			   public."tbCompReaseguradora".nombre_compannia_reaseguradora
		FROM public."tbCompReaseguradora" ;
END;
$$;
 1   DROP FUNCTION public.tbcompreaseguradora_read();
       public          postgres    false            \           1255    17825 !   tbcompreaseguradora_read(integer)    FUNCTION     z  CREATE FUNCTION public.tbcompreaseguradora_read(p_id_comp_reaseguradora integer) RETURNS TABLE(id_comp_reaseguradora integer, id_pais integer, id_tipo_reaseguro integer, nombre_compannia_reaseguradora character varying)
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
       public          postgres    false            (           1255    18201    tbcompreaseguradora_read_all()    FUNCTION     	  CREATE FUNCTION public.tbcompreaseguradora_read_all() RETURNS TABLE(id_comp_reaseguradora integer, id_pais integer, id_tipo_reaseguro integer, nombre_compannia_reaseguradora character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
		RETURN QUERY
		SELECT public."tbCompReaseguradora".id_comp_reaseguradora,
			   public."tbCompReaseguradora".id_pais , 
			   public."tbCompReaseguradora".id_tipo_reaseguro , 
			   public."tbCompReaseguradora".nombre_compannia_reaseguradora
		FROM public."tbCompReaseguradora" ;
END;
$$;
 5   DROP FUNCTION public.tbcompreaseguradora_read_all();
       public          postgres    false                       1255    17826 H   tbcompreaseguradora_update(integer, integer, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbcompreaseguradora_update(p_id_comp_reaseguradora integer, p_id_pais integer, p_id_tipo_reaseguro integer, p_nombre_compannia_reaseguradora character varying) RETURNS TABLE(id_comp_reaseguradora integer, id_pais integer, id_tipo_reaseguro integer, nombre_compannia_reaseguradora character varying)
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
       public          postgres    false                        1255    17827    tbestadopoliza_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbestadopoliza_read(p_id_estado_poliza integer) RETURNS TABLE(id_estado_poliza integer, nombre_estado_poliza character varying)
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
       public          postgres    false            K           1255    17828 !   tbestadoreclamacion_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbestadoreclamacion_read(p_id_estado_reclamacion integer) RETURNS TABLE(id_estado_reclamacion integer, nombre_estado_reclamacion character varying)
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
       public          postgres    false            U           1255    17829 )   tbmotivocancelacionpoliza_delete(integer)    FUNCTION     ^  CREATE FUNCTION public.tbmotivocancelacionpoliza_delete(p_numero_poliza integer) RETURNS boolean
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
       public          postgres    false                       1255    17830 /   tbmotivocancelacionpoliza_insert(integer, text)    FUNCTION     W  CREATE FUNCTION public.tbmotivocancelacionpoliza_insert(p_numero_poliza integer, p_descripcion_motivo text) RETURNS TABLE(numero_poliza integer, descripcion_motivo text)
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
       public          postgres    false            c           1255    17831 '   tbmotivocancelacionpoliza_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbmotivocancelacionpoliza_read(p_numero_poliza integer) RETURNS TABLE(numero_poliza integer, descripcion_motivo text)
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
       public          postgres    false                       1255    17832 /   tbmotivocancelacionpoliza_update(integer, text)    FUNCTION     y  CREATE FUNCTION public.tbmotivocancelacionpoliza_update(p_numero_poliza integer, p_descripcion_motivo text) RETURNS TABLE(numero_poliza integer, descripcion_motivo text)
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
       public          postgres    false                       1255    17833 *   tbmotivorechazoreclamacion_delete(integer)    FUNCTION     q  CREATE FUNCTION public.tbmotivorechazoreclamacion_delete(p_numero_reclamacion integer) RETURNS boolean
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
       public          postgres    false            V           1255    17834 0   tbmotivorechazoreclamacion_insert(integer, text)    FUNCTION     r  CREATE FUNCTION public.tbmotivorechazoreclamacion_insert(p_numero_reclamacion integer, p_motivo_rechazo text) RETURNS TABLE(numero_reclamacion integer, motivo_rechazo text)
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
       public          postgres    false            N           1255    17835 (   tbmotivorechazoreclamacion_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbmotivorechazoreclamacion_read(p_numero_reclamacion integer) RETURNS TABLE(numero_reclamacion integer, motivo_rechazo text)
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
       public          postgres    false                       1255    17836 0   tbmotivorechazoreclamacion_update(integer, text)    FUNCTION     �  CREATE FUNCTION public.tbmotivorechazoreclamacion_update(p_numero_reclamacion integer, p_motivo_rechazo text) RETURNS TABLE(numero_reclamacion integer, motivo_rechazo text)
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
       public          postgres    false            
           1255    17837    tbpais_delete(integer)    FUNCTION     D  CREATE FUNCTION public.tbpais_delete(p_id_pais integer) RETURNS boolean
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
       public          postgres    false            P           1255    17838     tbpais_insert(character varying)    FUNCTION     �  CREATE FUNCTION public.tbpais_insert(p_nombre_pais character varying) RETURNS TABLE(id_pais integer, nombre_pais character varying)
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
       public          postgres    false            #           1255    17839    tbpais_read(integer)    FUNCTION     8  CREATE FUNCTION public.tbpais_read(p_id_pais integer) RETURNS TABLE(id_pais integer, nombre_pais character varying)
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
       public          postgres    false            >           1255    18193    tbpais_read_all()    FUNCTION       CREATE FUNCTION public.tbpais_read_all() RETURNS TABLE(id_pais integer, nombre_pais character varying)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
		SELECT public."tbPais".id_pais, public."tbPais".nombre_pais  
		FROM public."tbPais";
		
	END;
	$$;
 (   DROP FUNCTION public.tbpais_read_all();
       public          postgres    false                       1255    17840 )   tbpais_update(integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbpais_update(p_id_pais integer, p_nombre_pais character varying) RETURNS TABLE(id_pais integer, nombre_pais character varying)
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
       public          postgres    false            $           1255    17841    tbpoliza_delete(integer)    FUNCTION     .  CREATE FUNCTION public.tbpoliza_delete(p_numero_poliza integer) RETURNS boolean
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
       public          postgres    false                       1255    17842 T   tbpoliza_insert(integer, integer, integer, integer, date, date, real, real, integer)    FUNCTION     �  CREATE FUNCTION public.tbpoliza_insert(p_id_agencia_seguro integer, p_numero_identidad_cliente integer, p_id_estado_poliza integer, p_id_tipo_seguro integer, p_fecha_inicio date, p_fecha_fin date, p_prima_mensual real, p_monto_total_asegurado real, p_id_tipo_cobertura integer) RETURNS TABLE(numero_poliza integer, id_agencia_seguro integer, numero_identidad_cliente integer, id_estado_poliza integer, id_tipo_seguro integer, fecha_inicio date, fecha_fin date, prima_mensual real, monto_total_asegurado real, id_tipo_cobertura integer)
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
       public          postgres    false                       1255    17843    tbpoliza_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbpoliza_read(p_numero_poliza integer) RETURNS TABLE(numero_poliza integer, id_agencia_seguro integer, numero_identidad_cliente integer, id_estado_poliza integer, id_tipo_seguro integer, fecha_inicio date, fecha_fin date, prima_mensual double precision, monto_total_asegurado double precision, id_tipo_cobertura integer)
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
       public          postgres    false                       1255    18171    tbpoliza_read_all(integer)    FUNCTION     �  CREATE FUNCTION public.tbpoliza_read_all(p_numero_identidad_cliente integer) RETURNS TABLE(numero_poliza integer, id_agencia_seguro integer, numero_identidad_cliente integer, id_estado_poliza integer, id_tipo_seguro integer, fecha_inicio date, fecha_fin date, prima_mensual double precision, monto_total_asegurado double precision, id_tipo_cobertura integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT public."tbPoliza".numero_poliza, public."tbPoliza".id_agencia_seguro, public."tbPoliza".numero_identidad_cliente, 
           public."tbPoliza".id_estado_poliza, public."tbPoliza".id_tipo_seguro, 
           public."tbPoliza".fecha_inicio, public."tbPoliza".fecha_fin, 
           public."tbPoliza".prima_mensual, public."tbPoliza".monto_total_asegurado, 
           public."tbPoliza".id_tipo_cobertura
    FROM public."tbPoliza"
    WHERE public."tbPoliza".numero_identidad_cliente = p_numero_identidad_cliente;
END;
$$;
 L   DROP FUNCTION public.tbpoliza_read_all(p_numero_identidad_cliente integer);
       public          postgres    false            M           1255    18188    tbpoliza_read_all_polizas()    FUNCTION     K  CREATE FUNCTION public.tbpoliza_read_all_polizas() RETURNS TABLE(numero_poliza integer, id_agencia_seguro integer, numero_identidad_cliente integer, id_estado_poliza integer, id_tipo_seguro integer, fecha_inicio date, fecha_fin date, prima_mensual double precision, monto_total_asegurado double precision, id_tipo_cobertura integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT public."tbPoliza".numero_poliza, public."tbPoliza".id_agencia_seguro, public."tbPoliza".numero_identidad_cliente, 
           public."tbPoliza".id_estado_poliza, public."tbPoliza".id_tipo_seguro, 
           public."tbPoliza".fecha_inicio, public."tbPoliza".fecha_fin, 
           public."tbPoliza".prima_mensual, public."tbPoliza".monto_total_asegurado, 
           public."tbPoliza".id_tipo_cobertura
    FROM public."tbPoliza";
    
END;
$$;
 2   DROP FUNCTION public.tbpoliza_read_all_polizas();
       public          postgres    false            E           1255    17844 ]   tbpoliza_update(integer, integer, integer, integer, integer, date, date, real, real, integer)    FUNCTION       CREATE FUNCTION public.tbpoliza_update(p_numero_poliza integer, p_id_agencia_seguro integer, p_numero_identidad_cliente integer, p_id_estado_poliza integer, p_id_tipo_seguro integer, p_fecha_inicio date, p_fecha_fin date, p_prima_mensual real, p_monto_total_asegurado real, p_id_tipo_cobertura integer) RETURNS TABLE(numero_poliza integer, id_agencia_seguro integer, numero_identidad_cliente integer, id_estado_poliza integer, id_tipo_seguro integer, fecha_inicio date, fecha_fin date, prima_mensual real, monto_total_asegurado real, id_tipo_cobertura integer)
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
       public          postgres    false            O           1255    17845 8   tbporcentparticipacion_delete(integer, integer, integer)    FUNCTION     .  CREATE FUNCTION public.tbporcentparticipacion_delete(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer) RETURNS boolean
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
       public          postgres    false            H           1255    17846 J   tbporcentparticipacion_insert(integer, integer, integer, double precision)    FUNCTION     [  CREATE FUNCTION public.tbporcentparticipacion_insert(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer, p_porciento_participacion double precision) RETURNS TABLE(id_agencia_seguro integer, id_tipo_seguro integer, id_comp_reaseguradora integer, porciento_participacion double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbPorcentParticipacion" (id_agencia_seguro , id_tipo_seguro , id_comp_reaseguradora , porciento_participacion)
	VALUES (p_id_agencia_seguro , p_id_tipo_seguro, p_id_comp_reaseguradora, p_porciento_participacion);
END;
$$;
 �   DROP FUNCTION public.tbporcentparticipacion_insert(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer, p_porciento_participacion double precision);
       public          postgres    false            I           1255    17847 6   tbporcentparticipacion_read(integer, integer, integer)    FUNCTION     ;  CREATE FUNCTION public.tbporcentparticipacion_read(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer) RETURNS TABLE(id_agencia_seguro integer, id_tipo_seguro integer, id_comp_reaseguradora integer, porciento_participacion double precision)
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
       public          postgres    false            ]           1255    17848 J   tbporcentparticipacion_update(integer, integer, integer, double precision)    FUNCTION     �  CREATE FUNCTION public.tbporcentparticipacion_update(p_id_agencia_seguro integer, p_id_tipo_seguro integer, p_id_comp_reaseguradora integer, p_porciento_participacion double precision) RETURNS TABLE(id_agencia_seguro integer, id_tipo_seguro integer, id_comp_reaseguradora integer, porciento_participacion double precision)
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
       public          postgres    false            f           1255    17849 0   tbprimamensual_delete(integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.tbprimamensual_delete(p_numero_poliza integer, p_mes integer, p_anno integer) RETURNS boolean
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
       public          postgres    false            L           1255    17850 B   tbprimamensual_insert(integer, double precision, integer, integer)    FUNCTION     �  CREATE FUNCTION public.tbprimamensual_insert(p_numero_poliza integer, p_monto_pagado double precision, p_mes integer, p_anno integer) RETURNS TABLE(numero_poliza integer, monto_pagado double precision, mes integer, anno integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbPrimaMensual" (numero_poliza , monto_pagado , mes , anno )
	VALUES (p_numero_poliza , p_monto_pagado , p_mes , p_anno);
END;
$$;
 �   DROP FUNCTION public.tbprimamensual_insert(p_numero_poliza integer, p_monto_pagado double precision, p_mes integer, p_anno integer);
       public          postgres    false            e           1255    17851 .   tbprimamensual_read(integer, integer, integer)    FUNCTION     U  CREATE FUNCTION public.tbprimamensual_read(p_numero_poliza integer, p_mes integer, p_anno integer) RETURNS TABLE(numero_poliza integer, monto_pagado double precision, mes integer, anno integer)
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
       public          postgres    false                       1255    17852 B   tbprimamensual_update(integer, double precision, integer, integer)    FUNCTION     �  CREATE FUNCTION public.tbprimamensual_update(p_numero_poliza integer, p_monto_pagado double precision, p_mes integer, p_anno integer) RETURNS TABLE(numero_poliza integer, monto_pagado double precision, mes integer, anno integer)
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
       public          postgres    false            Q           1255    17853    tbreclamacion_delete(integer)    FUNCTION     @  CREATE FUNCTION public.tbreclamacion_delete(p_numero_reclamacion integer) RETURNS boolean
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
       public          postgres    false            ?           1255    17854 Y   tbreclamacion_insert(integer, integer, integer, date, double precision, double precision)    FUNCTION     $  CREATE FUNCTION public.tbreclamacion_insert(p_numero_poliza integer, p_id_estado_reclamacion integer, p_id_tipo_siniestro integer, p_fecha_siniestro date, p_monto_reclamado double precision, p_monto_indemnizado double precision) RETURNS TABLE(numero_reclamacion integer, numero_poliza integer, id_estado_reclamacion integer, id_tipo_siniestro integer, fecha_siniestro date, monto_reclamado double precision, monto_indemnizado double precision)
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
       public          postgres    false                       1255    17855    tbreclamacion_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbreclamacion_read(p_numero_reclamacion integer) RETURNS TABLE(numero_reclamacion integer, numero_poliza integer, id_estado_reclamacion integer, id_tipo_siniestro integer, fecha_siniestro date, monto_reclamado double precision, monto_indemnizado double precision)
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
       public          postgres    false            a           1255    18199    tbreclamacion_read_all()    FUNCTION     �  CREATE FUNCTION public.tbreclamacion_read_all() RETURNS TABLE(numero_reclamacion integer, numero_poliza integer, id_estado_reclamacion integer, id_tipo_siniestro integer, fecha_siniestro date, monto_reclamado double precision, monto_indemnizado double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbReclamacion".numero_reclamacion, public."tbReclamacion".numero_poliza, public."tbReclamacion".id_estado_reclamacion, 
		   public."tbReclamacion".id_tipo_siniestro, public."tbReclamacion".fecha_siniestro, 
		   public."tbReclamacion".monto_reclamado, public."tbReclamacion".monto_indemnizado 
	FROM public."tbReclamacion";
END;
$$;
 /   DROP FUNCTION public.tbreclamacion_read_all();
       public          postgres    false            8           1255    17856 b   tbreclamacion_update(integer, integer, integer, integer, date, double precision, double precision)    FUNCTION     q  CREATE FUNCTION public.tbreclamacion_update(p_numero_reclamacion integer, p_numero_poliza integer, p_id_estado_reclamacion integer, p_id_tipo_siniestro integer, p_fecha_siniestro date, p_monto_reclamado double precision, p_monto_indemnizado double precision) RETURNS TABLE(numero_reclamacion integer, numero_poliza integer, id_estado_reclamacion integer, id_tipo_siniestro integer, fecha_siniestro date, monto_reclamado double precision, monto_indemnizado double precision)
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
       public          postgres    false            .           1255    17857 +   tbsegurosdeagencia_delete(integer, integer)    FUNCTION     �  CREATE FUNCTION public.tbsegurosdeagencia_delete(p_id_tipo_seguro integer, p_id_agencia_seguro integer) RETURNS boolean
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
       public          postgres    false                       1255    17858 +   tbsegurosdeagencia_insert(integer, integer)    FUNCTION     U  CREATE FUNCTION public.tbsegurosdeagencia_insert(p_id_tipo_seguro integer, p_id_agencia_seguro integer) RETURNS TABLE(id_tipo_seguro integer, id_agencia_seguro integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbSegurosDeAgencia" (id_tipo_seguro, id_agencia_seguro)
	VALUES (p_id_tipo_seguro, p_id_agencia_seguro);
END;
$$;
 g   DROP FUNCTION public.tbsegurosdeagencia_insert(p_id_tipo_seguro integer, p_id_agencia_seguro integer);
       public          postgres    false            ;           1255    17859     tbsegurosdeagencia_read(integer)    FUNCTION       CREATE FUNCTION public.tbsegurosdeagencia_read(p_id_agencia_seguro integer) RETURNS TABLE(nombre_tipo_seguro character varying, id_agencia_seguro integer)
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
       public          postgres    false            0           1255    17860    tbsexo_read(integer)    FUNCTION     /  CREATE FUNCTION public.tbsexo_read(p_id_sexo integer) RETURNS TABLE(id_sexo integer, nombre_sexo character varying)
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
       public          postgres    false            +           1255    18191    tbsexo_read_all()    FUNCTION     �   CREATE FUNCTION public.tbsexo_read_all() RETURNS TABLE(id_sexo integer, nombre_sexo character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbSexo".id_sexo, public."tbSexo".nombre_sexo
	FROM public."tbSexo";
	
END;
$$;
 (   DROP FUNCTION public.tbsexo_read_all();
       public          postgres    false            X           1255    17861    tbtipocobertura_delete(integer)    FUNCTION     D  CREATE FUNCTION public.tbtipocobertura_delete(p_id_tipo_cobertura integer) RETURNS boolean
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
       public          postgres    false            &           1255    17862 )   tbtipocobertura_insert(character varying)    FUNCTION     9  CREATE FUNCTION public.tbtipocobertura_insert(p_nombre_tipo_cobertura character varying) RETURNS TABLE(id_tipo_cobertura integer, nombre_tipo_cobertura character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbTipoCobertura" (nombre_tipo_cobertura) VALUES (p_nombre_tipo_cobertura);
END;
$$;
 X   DROP FUNCTION public.tbtipocobertura_insert(p_nombre_tipo_cobertura character varying);
       public          postgres    false            G           1255    17863    tbtipocobertura_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbtipocobertura_read(p_id_tipo_cobertura integer) RETURNS TABLE(id_tipo_cobertura integer, nombre_tipo_cobertura character varying)
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
       public          postgres    false            =           1255    18172    tbtipocobertura_read_all()    FUNCTION     C  CREATE FUNCTION public.tbtipocobertura_read_all() RETURNS TABLE(id_tipo_cobertura integer, nombre_tipo_cobertura character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbTipoCobertura".id_tipo_cobertura, public."tbTipoCobertura".nombre_tipo_cobertura
	FROM public."tbTipoCobertura";
END;
$$;
 1   DROP FUNCTION public.tbtipocobertura_read_all();
       public          postgres    false                       1255    17864 2   tbtipocobertura_update(integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbtipocobertura_update(p_id_tipo_cobertura integer, p_nombre_tipo_cobertura character varying) RETURNS TABLE(id_tipo_cobertura integer, nombre_tipo_cobertura character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbTipoCobertura" SET nombre_tipo_cobertura= p_nombre_tipo_cobertura
	WHERE public."tbTipoCobertura".id_tipo_cobertura= p_id_tipo_cobertura;
END;
$$;
 u   DROP FUNCTION public.tbtipocobertura_update(p_id_tipo_cobertura integer, p_nombre_tipo_cobertura character varying);
       public          postgres    false                       1255    17865    tbtiporeaseguro_delete(integer)    FUNCTION     D  CREATE FUNCTION public.tbtiporeaseguro_delete(p_id_tipo_reaseguro integer) RETURNS boolean
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
       public          postgres    false            )           1255    17866 )   tbtiporeaseguro_insert(character varying)    FUNCTION     9  CREATE FUNCTION public.tbtiporeaseguro_insert(p_nombre_tipo_reaseguro character varying) RETURNS TABLE(id_tipo_reaseguro integer, nombre_tipo_reaseguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbTipoReaseguro" (nombre_tipo_reaseguro) VALUES (p_nombre_tipo_reaseguro);
END;
$$;
 X   DROP FUNCTION public.tbtiporeaseguro_insert(p_nombre_tipo_reaseguro character varying);
       public          postgres    false                       1255    17867    tbtiporeaseguro_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbtiporeaseguro_read(p_id_tipo_reaseguro integer) RETURNS TABLE(id_tipo_reaseguro integer, nombre_tipo_reaseguro character varying)
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
       public          postgres    false            R           1255    17868 2   tbtiporeaseguro_update(integer, character varying)    FUNCTION     �  CREATE FUNCTION public.tbtiporeaseguro_update(p_id_tipo_reaseguro integer, p_nombre_tipo_reaseguro character varying) RETURNS TABLE(id_tipo_reaseguro integer, nombre_tipo_reaseguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbTipoReaseguro" SET nombre_tipo_reaseguro= p_nombre_tipo_reaseguro
	WHERE public."tbTipoReaseguro".id_tipo_reaseguro= p_id_tipo_reaseguro;
END;
$$;
 u   DROP FUNCTION public.tbtiporeaseguro_update(p_id_tipo_reaseguro integer, p_nombre_tipo_reaseguro character varying);
       public          postgres    false                       1255    17869    tbtiposeguro_delete(integer)    FUNCTION     2  CREATE FUNCTION public.tbtiposeguro_delete(p_id_tipo_seguro integer) RETURNS boolean
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
       public          postgres    false            9           1255    17870 &   tbtiposeguro_insert(character varying)    FUNCTION       CREATE FUNCTION public.tbtiposeguro_insert(p_nombre_seguro character varying) RETURNS TABLE(id_tipo_seguro integer, nombre_tipo_seguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbTipoSeguro" (nombre_tipo_seguro) VALUES (p_nombre_seguro);
END;
$$;
 M   DROP FUNCTION public.tbtiposeguro_insert(p_nombre_seguro character varying);
       public          postgres    false            %           1255    17871    tbtiposeguro_read(integer)    FUNCTION     ~  CREATE FUNCTION public.tbtiposeguro_read(p_id_tipo_seguro integer) RETURNS TABLE(id_tipo_seguro integer, nombre_tipo_seguro character varying)
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
       public          postgres    false            Z           1255    18173    tbtiposeguro_read_all()    FUNCTION     +  CREATE FUNCTION public.tbtiposeguro_read_all() RETURNS TABLE(id_tipo_seguro integer, nombre_tipo_seguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbTipoSeguro".id_tipo_seguro, public."tbTipoSeguro".nombre_tipo_seguro
	FROM public."tbTipoSeguro";
END;
$$;
 .   DROP FUNCTION public.tbtiposeguro_read_all();
       public          postgres    false            `           1255    17872 /   tbtiposeguro_update(integer, character varying)    FUNCTION     q  CREATE FUNCTION public.tbtiposeguro_update(p_id_tipo_seguro integer, p_nombre_tipo_seguro character varying) RETURNS TABLE(id_tipo_seguro integer, nombre_tipo_seguro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbTipoSeguro" SET nombre_tipo_seguro= p_nombre_tipo_seguro
	WHERE public."tbTipoSeguro".id_tipo_seguro= p_id_tipo_seguro;
END;
$$;
 l   DROP FUNCTION public.tbtiposeguro_update(p_id_tipo_seguro integer, p_nombre_tipo_seguro character varying);
       public          postgres    false            D           1255    17873    tbtiposiniestro_delete(integer)    FUNCTION     D  CREATE FUNCTION public.tbtiposiniestro_delete(p_id_tipo_siniestro integer) RETURNS boolean
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
       public          postgres    false            <           1255    17874 )   tbtiposiniestro_insert(character varying)    FUNCTION     %  CREATE FUNCTION public.tbtiposiniestro_insert(p_nombre_siniestro character varying) RETURNS TABLE(id_tipo_siniestro integer, nombre_siniestro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO public."tbTipoSiniestro" (nombre_siniestro) VALUES (p_nombre_siniestro);
END;
$$;
 S   DROP FUNCTION public.tbtiposiniestro_insert(p_nombre_siniestro character varying);
       public          postgres    false            '           1255    17875    tbtiposiniestro_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbtiposiniestro_read(p_id_tipo_siniestro integer) RETURNS TABLE(id_tipo_siniestro integer, nombre_siniestro character varying)
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
       public          postgres    false                       1255    17876 2   tbtiposiniestro_update(integer, character varying)    FUNCTION     ~  CREATE FUNCTION public.tbtiposiniestro_update(p_id_tipo_siniestro integer, p_nombre_siniestro character varying) RETURNS TABLE(id_tipo_siniestro integer, nombre_siniestro character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbTipoSiniestro" SET nombre_siniestro= p_nombre_siniestro
	WHERE public."tbTipoSiniestro".id_tipo_siniestro= p_id_tipo_siniestro;
END;
$$;
 p   DROP FUNCTION public.tbtiposiniestro_update(p_id_tipo_siniestro integer, p_nombre_siniestro character varying);
       public          postgres    false            h           1255    17877    tbusuarios_delete(integer)    FUNCTION        CREATE FUNCTION public.tbusuarios_delete(p_id_usuario integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE resultado bool;
BEGIN
	resultado := true;
	BEGIN
	DELETE FROM public."tbUsuarios"
	WHERE public."tbUsuarios".id_usuario = p_id_usuario;
	END;
	RETURN resultado;
END;
$$;
 >   DROP FUNCTION public.tbusuarios_delete(p_id_usuario integer);
       public          postgres    false            5           1255    18196 0   tbusuarios_insert(text, text, character varying)    FUNCTION     	  CREATE FUNCTION public.tbusuarios_insert(p_nombre_usuario text, p_contrasenna text, p_rol character varying) RETURNS TABLE(id_usuario integer, nombre_usuario text, contrasenna text, rol character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN query
	INSERT INTO public."tbUsuarios" (nombre_usuario ,contrasenna , rol)
	VALUES (p_nombre_usuario , p_contrasenna , p_rol)
	RETURNING public."tbUsuarios".id_usuario, public."tbUsuarios".nombre_usuario, public."tbUsuarios".contrasenna, public."tbUsuarios".rol;
END;
$$;
 l   DROP FUNCTION public.tbusuarios_insert(p_nombre_usuario text, p_contrasenna text, p_rol character varying);
       public          postgres    false            S           1255    17879    tbusuarios_read(integer)    FUNCTION     �  CREATE FUNCTION public.tbusuarios_read(p_id_usuario integer) RETURNS TABLE(id_usuario integer, nombre_usuario text, contrasenna text, rol character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbUsuarios".id_usuario,
			public."tbUsuarios".nombre_usuario, 
			public."tbUsuarios".contrasenna , public."tbUsuarios".rol
	FROM public."tbUsuarios"
	WHERE public."tbUsuarios".id_usuario = p_id_usuario;
	 
END;
$$;
 <   DROP FUNCTION public.tbusuarios_read(p_id_usuario integer);
       public          postgres    false            6           1255    18203    tbusuarios_read_all()    FUNCTION     t  CREATE FUNCTION public.tbusuarios_read_all() RETURNS TABLE(id_usuario integer, nombre_usuario text, contrasenna text, rol character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbUsuarios".id_usuario,
			public."tbUsuarios".nombre_usuario, 
			public."tbUsuarios".contrasenna , public."tbUsuarios".rol
	FROM public."tbUsuarios";
	 
END;
$$;
 ,   DROP FUNCTION public.tbusuarios_read_all();
       public          postgres    false            J           1255    17880 9   tbusuarios_update(integer, text, text, character varying)    FUNCTION     �  CREATE FUNCTION public.tbusuarios_update(p_id_usuario integer, p_nombre_usuario text, p_contrasenna text, p_rol character varying) RETURNS TABLE(id_usuario integer, nombre_usuario text, contrasenna text, rol character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."tbUsuarios" SET nombre_usuario=p_nombre_usuario, contrasenna = p_contrasenna , rol=p_rol
	WHERE public."tbUsuarios".id_usuario = p_id_usuario;
END;
$$;
 �   DROP FUNCTION public.tbusuarios_update(p_id_usuario integer, p_nombre_usuario text, p_contrasenna text, p_rol character varying);
       public          postgres    false            �            1259    17881 	   tbCliente    TABLE     �  CREATE TABLE public."tbCliente" (
    numero_identidad_cliente integer NOT NULL,
    id_pais integer NOT NULL,
    id_sexo integer NOT NULL,
    nombre_cliente character varying(50) NOT NULL,
    apellido_cliente character varying(50),
    edad integer NOT NULL,
    direccion_postal character varying(255),
    telefono character varying(50),
    correo_electronico character varying(255) NOT NULL,
    carnet_identidad character varying(11)
);
    DROP TABLE public."tbCliente";
       public         heap    postgres    false            �            1259    17886    tbEstadoReclamacion    TABLE     �   CREATE TABLE public."tbEstadoReclamacion" (
    id_estado_reclamacion integer NOT NULL,
    nombre_estado_reclamacion character varying(50) NOT NULL
);
 )   DROP TABLE public."tbEstadoReclamacion";
       public         heap    postgres    false            �            1259    17889    tbPoliza    TABLE     �  CREATE TABLE public."tbPoliza" (
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
       public         heap    postgres    false            �            1259    17892    tbReclamacion    TABLE     C  CREATE TABLE public."tbReclamacion" (
    numero_reclamacion integer NOT NULL,
    numero_poliza integer NOT NULL,
    id_estado_reclamacion integer NOT NULL,
    id_tipo_siniestro integer NOT NULL,
    fecha_siniestro date NOT NULL,
    monto_reclamado double precision NOT NULL,
    monto_indemnizado double precision
);
 #   DROP TABLE public."tbReclamacion";
       public         heap    postgres    false            �            1259    17895    tbTipoSeguro    TABLE     �   CREATE TABLE public."tbTipoSeguro" (
    id_tipo_seguro integer NOT NULL,
    nombre_tipo_seguro character varying(50) NOT NULL
);
 "   DROP TABLE public."tbTipoSeguro";
       public         heap    postgres    false            �            1259    17898    tbTipoSiniestro    TABLE     �   CREATE TABLE public."tbTipoSiniestro" (
    id_tipo_siniestro integer NOT NULL,
    nombre_siniestro character varying(255) NOT NULL
);
 %   DROP TABLE public."tbTipoSiniestro";
       public         heap    postgres    false            �            1259    17901    reporte_estado_reclamaciones    VIEW     �  CREATE VIEW public.reporte_estado_reclamaciones AS
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
       public          postgres    false    218    219    218    218    218    218    218    218    217    217    217    216    216    215    215    220    220    219            �            1259    17906    tbPais    TABLE     o   CREATE TABLE public."tbPais" (
    id_pais integer NOT NULL,
    nombre_pais character varying(50) NOT NULL
);
    DROP TABLE public."tbPais";
       public         heap    postgres    false            �            1259    17909    reporte_paises    VIEW     r   CREATE VIEW public.reporte_paises AS
 SELECT id_pais,
    nombre_pais
   FROM public."tbPais"
  ORDER BY id_pais;
 !   DROP VIEW public.reporte_paises;
       public          postgres    false    222    222            �            1259    17913    tbSexo    TABLE     k   CREATE TABLE public."tbSexo" (
    id_sexo integer NOT NULL,
    nombre_sexo character varying NOT NULL
);
    DROP TABLE public."tbSexo";
       public         heap    postgres    false            �            1259    17918    reporte_roger_clientes    VIEW     �  CREATE VIEW public.reporte_roger_clientes AS
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
       public          postgres    false    224    215    215    215    215    222    222    224    215    215    215    215            �            1259    17922    reporte_tipos_de_seguros    VIEW     �   CREATE VIEW public.reporte_tipos_de_seguros AS
 SELECT id_tipo_seguro,
    nombre_tipo_seguro
   FROM public."tbTipoSeguro"
  ORDER BY id_tipo_seguro;
 +   DROP VIEW public.reporte_tipos_de_seguros;
       public          postgres    false    219    219            �            1259    17926 0   salida_cliente_con_cantidad_reclamacion_aprobada    VIEW     �   CREATE VIEW public.salida_cliente_con_cantidad_reclamacion_aprobada AS
SELECT
    NULL::character varying(50) AS nombre_cliente,
    NULL::integer AS numero_identidad_cliente,
    NULL::bigint AS count,
    NULL::double precision AS sum;
 C   DROP VIEW public.salida_cliente_con_cantidad_reclamacion_aprobada;
       public          postgres    false            �            1259    17930 1   salida_cliente_con_cantidad_reclamacion_rechazada    VIEW     �   CREATE VIEW public.salida_cliente_con_cantidad_reclamacion_rechazada AS
SELECT
    NULL::character varying(50) AS nombre_cliente,
    NULL::integer AS numero_identidad_cliente,
    NULL::bigint AS count;
 D   DROP VIEW public.salida_cliente_con_cantidad_reclamacion_rechazada;
       public          postgres    false            �            1259    17934    salida_listado_polizas_vencidas    VIEW       CREATE VIEW public.salida_listado_polizas_vencidas AS
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
       public          postgres    false    217    219    219    217    217    217    217    217    217    215    215            �            1259    17938    tbCompReaseguradora    TABLE     �   CREATE TABLE public."tbCompReaseguradora" (
    id_comp_reaseguradora integer NOT NULL,
    id_pais integer NOT NULL,
    id_tipo_reaseguro integer NOT NULL,
    nombre_compannia_reaseguradora character varying(255) NOT NULL
);
 )   DROP TABLE public."tbCompReaseguradora";
       public         heap    postgres    false            �            1259    17941    tbTipoReaseguro    TABLE     �   CREATE TABLE public."tbTipoReaseguro" (
    id_tipo_reaseguro integer NOT NULL,
    nombre_tipo_reaseguro character varying(50) NOT NULL
);
 %   DROP TABLE public."tbTipoReaseguro";
       public         heap    postgres    false            �            1259    17944    salida_listado_reaseguradoras    VIEW     �  CREATE VIEW public.salida_listado_reaseguradoras AS
 SELECT "tbCompReaseguradora".nombre_compannia_reaseguradora,
    "tbPais".nombre_pais,
    "tbTipoReaseguro".nombre_tipo_reaseguro
   FROM public."tbPais",
    public."tbTipoReaseguro",
    public."tbCompReaseguradora"
  WHERE (("tbCompReaseguradora".id_tipo_reaseguro = "tbTipoReaseguro".id_tipo_reaseguro) AND ("tbCompReaseguradora".id_pais = "tbPais".id_pais));
 0   DROP VIEW public.salida_listado_reaseguradoras;
       public          postgres    false    231    222    222    230    230    230    231            �            1259    17948    salida_listado_reclamaciones    VIEW     �  CREATE VIEW public.salida_listado_reclamaciones AS
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
       public          postgres    false    218    220    217    220    219    219    216    216    215    215    218    218    218    217    217    218    218    218            �            1259    17953    tbAgenciaSeguro    TABLE     �  CREATE TABLE public."tbAgenciaSeguro" (
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
       public         heap    postgres    false            �            1259    17958 %   tbAgenciaSeguro_id_agencia_seguro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbAgenciaSeguro_id_agencia_seguro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."tbAgenciaSeguro_id_agencia_seguro_seq";
       public          postgres    false    234            8           0    0 %   tbAgenciaSeguro_id_agencia_seguro_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."tbAgenciaSeguro_id_agencia_seguro_seq" OWNED BY public."tbAgenciaSeguro".id_agencia_seguro;
          public          postgres    false    235            �            1259    17959 &   tbCliente_numero_identidad_cliente_seq    SEQUENCE     �   CREATE SEQUENCE public."tbCliente_numero_identidad_cliente_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public."tbCliente_numero_identidad_cliente_seq";
       public          postgres    false    215            9           0    0 &   tbCliente_numero_identidad_cliente_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public."tbCliente_numero_identidad_cliente_seq" OWNED BY public."tbCliente".numero_identidad_cliente;
          public          postgres    false    236            �            1259    17960 -   tbCompReaseguradora_id_comp_reaseguradora_seq    SEQUENCE     �   CREATE SEQUENCE public."tbCompReaseguradora_id_comp_reaseguradora_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 F   DROP SEQUENCE public."tbCompReaseguradora_id_comp_reaseguradora_seq";
       public          postgres    false    230            :           0    0 -   tbCompReaseguradora_id_comp_reaseguradora_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."tbCompReaseguradora_id_comp_reaseguradora_seq" OWNED BY public."tbCompReaseguradora".id_comp_reaseguradora;
          public          postgres    false    237            �            1259    17961    tbEstadoPoliza    TABLE     �   CREATE TABLE public."tbEstadoPoliza" (
    id_estado_poliza integer NOT NULL,
    nombre_estado_poliza character varying(50) NOT NULL
);
 $   DROP TABLE public."tbEstadoPoliza";
       public         heap    postgres    false            �            1259    17964 #   tbEstadoPoliza_id_estado_poliza_seq    SEQUENCE     �   CREATE SEQUENCE public."tbEstadoPoliza_id_estado_poliza_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."tbEstadoPoliza_id_estado_poliza_seq";
       public          postgres    false    238            ;           0    0 #   tbEstadoPoliza_id_estado_poliza_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public."tbEstadoPoliza_id_estado_poliza_seq" OWNED BY public."tbEstadoPoliza".id_estado_poliza;
          public          postgres    false    239            �            1259    17965 -   tbEstadoReclamacion_id_estado_reclamacion_seq    SEQUENCE     �   CREATE SEQUENCE public."tbEstadoReclamacion_id_estado_reclamacion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 F   DROP SEQUENCE public."tbEstadoReclamacion_id_estado_reclamacion_seq";
       public          postgres    false    216            <           0    0 -   tbEstadoReclamacion_id_estado_reclamacion_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."tbEstadoReclamacion_id_estado_reclamacion_seq" OWNED BY public."tbEstadoReclamacion".id_estado_reclamacion;
          public          postgres    false    240            �            1259    17966    tbMotivoCancelacionPoliza    TABLE     ~   CREATE TABLE public."tbMotivoCancelacionPoliza" (
    numero_poliza integer NOT NULL,
    descripcion_motivo text NOT NULL
);
 /   DROP TABLE public."tbMotivoCancelacionPoliza";
       public         heap    postgres    false            �            1259    17971    tbMotivoRechazoReclamacion    TABLE     �   CREATE TABLE public."tbMotivoRechazoReclamacion" (
    numero_reclamacion integer NOT NULL,
    motivo_rechazo text NOT NULL
);
 0   DROP TABLE public."tbMotivoRechazoReclamacion";
       public         heap    postgres    false            �            1259    17976    tbPais_id_pais_seq    SEQUENCE     �   CREATE SEQUENCE public."tbPais_id_pais_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."tbPais_id_pais_seq";
       public          postgres    false    222            =           0    0    tbPais_id_pais_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."tbPais_id_pais_seq" OWNED BY public."tbPais".id_pais;
          public          postgres    false    243            �            1259    17977    tbPoliza_numero_poliza_seq    SEQUENCE     �   CREATE SEQUENCE public."tbPoliza_numero_poliza_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."tbPoliza_numero_poliza_seq";
       public          postgres    false    217            >           0    0    tbPoliza_numero_poliza_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."tbPoliza_numero_poliza_seq" OWNED BY public."tbPoliza".numero_poliza;
          public          postgres    false    244            �            1259    17978    tbPorcentParticipacion    TABLE     �   CREATE TABLE public."tbPorcentParticipacion" (
    id_agencia_seguro integer NOT NULL,
    id_tipo_seguro integer NOT NULL,
    id_comp_reaseguradora integer NOT NULL,
    porciento_participacion double precision NOT NULL
);
 ,   DROP TABLE public."tbPorcentParticipacion";
       public         heap    postgres    false            �            1259    17981 ,   tbPorcentParticipacion_id_agencia_seguro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbPorcentParticipacion_id_agencia_seguro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public."tbPorcentParticipacion_id_agencia_seguro_seq";
       public          postgres    false    245            ?           0    0 ,   tbPorcentParticipacion_id_agencia_seguro_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."tbPorcentParticipacion_id_agencia_seguro_seq" OWNED BY public."tbPorcentParticipacion".id_agencia_seguro;
          public          postgres    false    246            �            1259    17982    tbPrimaMensual    TABLE     �   CREATE TABLE public."tbPrimaMensual" (
    numero_poliza integer NOT NULL,
    monto_pagado double precision NOT NULL,
    mes integer NOT NULL,
    anno integer NOT NULL
);
 $   DROP TABLE public."tbPrimaMensual";
       public         heap    postgres    false            �            1259    17985 $   tbReclamacion_numero_reclamacion_seq    SEQUENCE     �   CREATE SEQUENCE public."tbReclamacion_numero_reclamacion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public."tbReclamacion_numero_reclamacion_seq";
       public          postgres    false    218            @           0    0 $   tbReclamacion_numero_reclamacion_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."tbReclamacion_numero_reclamacion_seq" OWNED BY public."tbReclamacion".numero_reclamacion;
          public          postgres    false    248            �            1259    17986    tbSegurosDeAgencia    TABLE     z   CREATE TABLE public."tbSegurosDeAgencia" (
    id_tipo_seguro integer NOT NULL,
    id_agencia_seguro integer NOT NULL
);
 (   DROP TABLE public."tbSegurosDeAgencia";
       public         heap    postgres    false            �            1259    17989    tbSexo_id_sexo_seq    SEQUENCE     �   CREATE SEQUENCE public."tbSexo_id_sexo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."tbSexo_id_sexo_seq";
       public          postgres    false    224            A           0    0    tbSexo_id_sexo_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."tbSexo_id_sexo_seq" OWNED BY public."tbSexo".id_sexo;
          public          postgres    false    250            �            1259    17990    tbTipoCobertura    TABLE     �   CREATE TABLE public."tbTipoCobertura" (
    id_tipo_cobertura integer NOT NULL,
    nombre_tipo_cobertura character varying NOT NULL
);
 %   DROP TABLE public."tbTipoCobertura";
       public         heap    postgres    false            �            1259    17995 %   tbTipoCobertura_id_tipo_cobertura_seq    SEQUENCE     �   CREATE SEQUENCE public."tbTipoCobertura_id_tipo_cobertura_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."tbTipoCobertura_id_tipo_cobertura_seq";
       public          postgres    false    251            B           0    0 %   tbTipoCobertura_id_tipo_cobertura_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."tbTipoCobertura_id_tipo_cobertura_seq" OWNED BY public."tbTipoCobertura".id_tipo_cobertura;
          public          postgres    false    252            �            1259    17996 %   tbTipoReaseguro_id_tipo_reaseguro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbTipoReaseguro_id_tipo_reaseguro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."tbTipoReaseguro_id_tipo_reaseguro_seq";
       public          postgres    false    231            C           0    0 %   tbTipoReaseguro_id_tipo_reaseguro_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."tbTipoReaseguro_id_tipo_reaseguro_seq" OWNED BY public."tbTipoReaseguro".id_tipo_reaseguro;
          public          postgres    false    253            �            1259    17997    tbTipoSeguro_id_tipo_seguro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbTipoSeguro_id_tipo_seguro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public."tbTipoSeguro_id_tipo_seguro_seq";
       public          postgres    false    219            D           0    0    tbTipoSeguro_id_tipo_seguro_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."tbTipoSeguro_id_tipo_seguro_seq" OWNED BY public."tbTipoSeguro".id_tipo_seguro;
          public          postgres    false    254            �            1259    17998 %   tbTipoSiniestro_id_tipo_siniestro_seq    SEQUENCE     �   CREATE SEQUENCE public."tbTipoSiniestro_id_tipo_siniestro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."tbTipoSiniestro_id_tipo_siniestro_seq";
       public          postgres    false    220            E           0    0 %   tbTipoSiniestro_id_tipo_siniestro_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."tbTipoSiniestro_id_tipo_siniestro_seq" OWNED BY public."tbTipoSiniestro".id_tipo_siniestro;
          public          postgres    false    255                        1259    17999 
   tbUsuarios    TABLE     �   CREATE TABLE public."tbUsuarios" (
    id_usuario integer NOT NULL,
    nombre_usuario text NOT NULL,
    contrasenna text NOT NULL,
    rol character varying NOT NULL
);
     DROP TABLE public."tbUsuarios";
       public         heap    postgres    false                       1259    18004    tbUsuarios_id_usuario_seq    SEQUENCE     �   CREATE SEQUENCE public."tbUsuarios_id_usuario_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."tbUsuarios_id_usuario_seq";
       public          postgres    false    256            F           0    0    tbUsuarios_id_usuario_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."tbUsuarios_id_usuario_seq" OWNED BY public."tbUsuarios".id_usuario;
          public          postgres    false    257            0           2604    18005 !   tbAgenciaSeguro id_agencia_seguro    DEFAULT     �   ALTER TABLE ONLY public."tbAgenciaSeguro" ALTER COLUMN id_agencia_seguro SET DEFAULT nextval('public."tbAgenciaSeguro_id_agencia_seguro_seq"'::regclass);
 R   ALTER TABLE public."tbAgenciaSeguro" ALTER COLUMN id_agencia_seguro DROP DEFAULT;
       public          postgres    false    235    234            .           2604    18007 )   tbCompReaseguradora id_comp_reaseguradora    DEFAULT     �   ALTER TABLE ONLY public."tbCompReaseguradora" ALTER COLUMN id_comp_reaseguradora SET DEFAULT nextval('public."tbCompReaseguradora_id_comp_reaseguradora_seq"'::regclass);
 Z   ALTER TABLE public."tbCompReaseguradora" ALTER COLUMN id_comp_reaseguradora DROP DEFAULT;
       public          postgres    false    237    230            1           2604    18008    tbEstadoPoliza id_estado_poliza    DEFAULT     �   ALTER TABLE ONLY public."tbEstadoPoliza" ALTER COLUMN id_estado_poliza SET DEFAULT nextval('public."tbEstadoPoliza_id_estado_poliza_seq"'::regclass);
 P   ALTER TABLE public."tbEstadoPoliza" ALTER COLUMN id_estado_poliza DROP DEFAULT;
       public          postgres    false    239    238            '           2604    18009 )   tbEstadoReclamacion id_estado_reclamacion    DEFAULT     �   ALTER TABLE ONLY public."tbEstadoReclamacion" ALTER COLUMN id_estado_reclamacion SET DEFAULT nextval('public."tbEstadoReclamacion_id_estado_reclamacion_seq"'::regclass);
 Z   ALTER TABLE public."tbEstadoReclamacion" ALTER COLUMN id_estado_reclamacion DROP DEFAULT;
       public          postgres    false    240    216            ,           2604    18010    tbPais id_pais    DEFAULT     t   ALTER TABLE ONLY public."tbPais" ALTER COLUMN id_pais SET DEFAULT nextval('public."tbPais_id_pais_seq"'::regclass);
 ?   ALTER TABLE public."tbPais" ALTER COLUMN id_pais DROP DEFAULT;
       public          postgres    false    243    222            (           2604    18011    tbPoliza numero_poliza    DEFAULT     �   ALTER TABLE ONLY public."tbPoliza" ALTER COLUMN numero_poliza SET DEFAULT nextval('public."tbPoliza_numero_poliza_seq"'::regclass);
 G   ALTER TABLE public."tbPoliza" ALTER COLUMN numero_poliza DROP DEFAULT;
       public          postgres    false    244    217            2           2604    18012 (   tbPorcentParticipacion id_agencia_seguro    DEFAULT     �   ALTER TABLE ONLY public."tbPorcentParticipacion" ALTER COLUMN id_agencia_seguro SET DEFAULT nextval('public."tbPorcentParticipacion_id_agencia_seguro_seq"'::regclass);
 Y   ALTER TABLE public."tbPorcentParticipacion" ALTER COLUMN id_agencia_seguro DROP DEFAULT;
       public          postgres    false    246    245            )           2604    18013     tbReclamacion numero_reclamacion    DEFAULT     �   ALTER TABLE ONLY public."tbReclamacion" ALTER COLUMN numero_reclamacion SET DEFAULT nextval('public."tbReclamacion_numero_reclamacion_seq"'::regclass);
 Q   ALTER TABLE public."tbReclamacion" ALTER COLUMN numero_reclamacion DROP DEFAULT;
       public          postgres    false    248    218            -           2604    18014    tbSexo id_sexo    DEFAULT     t   ALTER TABLE ONLY public."tbSexo" ALTER COLUMN id_sexo SET DEFAULT nextval('public."tbSexo_id_sexo_seq"'::regclass);
 ?   ALTER TABLE public."tbSexo" ALTER COLUMN id_sexo DROP DEFAULT;
       public          postgres    false    250    224            3           2604    18015 !   tbTipoCobertura id_tipo_cobertura    DEFAULT     �   ALTER TABLE ONLY public."tbTipoCobertura" ALTER COLUMN id_tipo_cobertura SET DEFAULT nextval('public."tbTipoCobertura_id_tipo_cobertura_seq"'::regclass);
 R   ALTER TABLE public."tbTipoCobertura" ALTER COLUMN id_tipo_cobertura DROP DEFAULT;
       public          postgres    false    252    251            /           2604    18016 !   tbTipoReaseguro id_tipo_reaseguro    DEFAULT     �   ALTER TABLE ONLY public."tbTipoReaseguro" ALTER COLUMN id_tipo_reaseguro SET DEFAULT nextval('public."tbTipoReaseguro_id_tipo_reaseguro_seq"'::regclass);
 R   ALTER TABLE public."tbTipoReaseguro" ALTER COLUMN id_tipo_reaseguro DROP DEFAULT;
       public          postgres    false    253    231            *           2604    18017    tbTipoSeguro id_tipo_seguro    DEFAULT     �   ALTER TABLE ONLY public."tbTipoSeguro" ALTER COLUMN id_tipo_seguro SET DEFAULT nextval('public."tbTipoSeguro_id_tipo_seguro_seq"'::regclass);
 L   ALTER TABLE public."tbTipoSeguro" ALTER COLUMN id_tipo_seguro DROP DEFAULT;
       public          postgres    false    254    219            +           2604    18018 !   tbTipoSiniestro id_tipo_siniestro    DEFAULT     �   ALTER TABLE ONLY public."tbTipoSiniestro" ALTER COLUMN id_tipo_siniestro SET DEFAULT nextval('public."tbTipoSiniestro_id_tipo_siniestro_seq"'::regclass);
 R   ALTER TABLE public."tbTipoSiniestro" ALTER COLUMN id_tipo_siniestro DROP DEFAULT;
       public          postgres    false    255    220            4           2604    18019    tbUsuarios id_usuario    DEFAULT     �   ALTER TABLE ONLY public."tbUsuarios" ALTER COLUMN id_usuario SET DEFAULT nextval('public."tbUsuarios_id_usuario_seq"'::regclass);
 F   ALTER TABLE public."tbUsuarios" ALTER COLUMN id_usuario DROP DEFAULT;
       public          postgres    false    257    256                      0    17953    tbAgenciaSeguro 
   TABLE DATA           �   COPY public."tbAgenciaSeguro" (id_agencia_seguro, nombre_agencia_seguro, direccion_postal, telefono, correo_electronico, nombre_director_general, nombre_jefe_departamento_seguros, nombre_jefe_departamento_reclamaciones) FROM stdin;
    public          postgres    false    234   E%                0    17881 	   tbCliente 
   TABLE DATA           �   COPY public."tbCliente" (numero_identidad_cliente, id_pais, id_sexo, nombre_cliente, apellido_cliente, edad, direccion_postal, telefono, correo_electronico, carnet_identidad) FROM stdin;
    public          postgres    false    215   �&                0    17938    tbCompReaseguradora 
   TABLE DATA           �   COPY public."tbCompReaseguradora" (id_comp_reaseguradora, id_pais, id_tipo_reaseguro, nombre_compannia_reaseguradora) FROM stdin;
    public          postgres    false    230   \(                0    17961    tbEstadoPoliza 
   TABLE DATA           R   COPY public."tbEstadoPoliza" (id_estado_poliza, nombre_estado_poliza) FROM stdin;
    public          postgres    false    238   �(                0    17886    tbEstadoReclamacion 
   TABLE DATA           a   COPY public."tbEstadoReclamacion" (id_estado_reclamacion, nombre_estado_reclamacion) FROM stdin;
    public          postgres    false    216   �(      !          0    17966    tbMotivoCancelacionPoliza 
   TABLE DATA           X   COPY public."tbMotivoCancelacionPoliza" (numero_poliza, descripcion_motivo) FROM stdin;
    public          postgres    false    241   #)      "          0    17971    tbMotivoRechazoReclamacion 
   TABLE DATA           Z   COPY public."tbMotivoRechazoReclamacion" (numero_reclamacion, motivo_rechazo) FROM stdin;
    public          postgres    false    242   I)                0    17906    tbPais 
   TABLE DATA           8   COPY public."tbPais" (id_pais, nombre_pais) FROM stdin;
    public          postgres    false    222   �)                0    17889    tbPoliza 
   TABLE DATA           �   COPY public."tbPoliza" (numero_poliza, id_agencia_seguro, numero_identidad_cliente, id_estado_poliza, id_tipo_seguro, fecha_inicio, fecha_fin, prima_mensual, monto_total_asegurado, id_tipo_cobertura) FROM stdin;
    public          postgres    false    217   x*      %          0    17978    tbPorcentParticipacion 
   TABLE DATA           �   COPY public."tbPorcentParticipacion" (id_agencia_seguro, id_tipo_seguro, id_comp_reaseguradora, porciento_participacion) FROM stdin;
    public          postgres    false    245   D+      '          0    17982    tbPrimaMensual 
   TABLE DATA           R   COPY public."tbPrimaMensual" (numero_poliza, monto_pagado, mes, anno) FROM stdin;
    public          postgres    false    247   |+                0    17892    tbReclamacion 
   TABLE DATA           �   COPY public."tbReclamacion" (numero_reclamacion, numero_poliza, id_estado_reclamacion, id_tipo_siniestro, fecha_siniestro, monto_reclamado, monto_indemnizado) FROM stdin;
    public          postgres    false    218   �+      )          0    17986    tbSegurosDeAgencia 
   TABLE DATA           Q   COPY public."tbSegurosDeAgencia" (id_tipo_seguro, id_agencia_seguro) FROM stdin;
    public          postgres    false    249   ,                0    17913    tbSexo 
   TABLE DATA           8   COPY public."tbSexo" (id_sexo, nombre_sexo) FROM stdin;
    public          postgres    false    224   >,      +          0    17990    tbTipoCobertura 
   TABLE DATA           U   COPY public."tbTipoCobertura" (id_tipo_cobertura, nombre_tipo_cobertura) FROM stdin;
    public          postgres    false    251   �,                0    17941    tbTipoReaseguro 
   TABLE DATA           U   COPY public."tbTipoReaseguro" (id_tipo_reaseguro, nombre_tipo_reaseguro) FROM stdin;
    public          postgres    false    231   �,                0    17895    tbTipoSeguro 
   TABLE DATA           L   COPY public."tbTipoSeguro" (id_tipo_seguro, nombre_tipo_seguro) FROM stdin;
    public          postgres    false    219   �,                0    17898    tbTipoSiniestro 
   TABLE DATA           P   COPY public."tbTipoSiniestro" (id_tipo_siniestro, nombre_siniestro) FROM stdin;
    public          postgres    false    220   1-      0          0    17999 
   tbUsuarios 
   TABLE DATA           T   COPY public."tbUsuarios" (id_usuario, nombre_usuario, contrasenna, rol) FROM stdin;
    public          postgres    false    256   �-      G           0    0 %   tbAgenciaSeguro_id_agencia_seguro_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."tbAgenciaSeguro_id_agencia_seguro_seq"', 9, true);
          public          postgres    false    235            H           0    0 &   tbCliente_numero_identidad_cliente_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public."tbCliente_numero_identidad_cliente_seq"', 15, true);
          public          postgres    false    236            I           0    0 -   tbCompReaseguradora_id_comp_reaseguradora_seq    SEQUENCE SET     ^   SELECT pg_catalog.setval('public."tbCompReaseguradora_id_comp_reaseguradora_seq"', 10, true);
          public          postgres    false    237            J           0    0 #   tbEstadoPoliza_id_estado_poliza_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."tbEstadoPoliza_id_estado_poliza_seq"', 3, true);
          public          postgres    false    239            K           0    0 -   tbEstadoReclamacion_id_estado_reclamacion_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public."tbEstadoReclamacion_id_estado_reclamacion_seq"', 3, true);
          public          postgres    false    240            L           0    0    tbPais_id_pais_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."tbPais_id_pais_seq"', 18, true);
          public          postgres    false    243            M           0    0    tbPoliza_numero_poliza_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."tbPoliza_numero_poliza_seq"', 76, true);
          public          postgres    false    244            N           0    0 ,   tbPorcentParticipacion_id_agencia_seguro_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public."tbPorcentParticipacion_id_agencia_seguro_seq"', 1, false);
          public          postgres    false    246            O           0    0 $   tbReclamacion_numero_reclamacion_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."tbReclamacion_numero_reclamacion_seq"', 9, true);
          public          postgres    false    248            P           0    0    tbSexo_id_sexo_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."tbSexo_id_sexo_seq"', 2, true);
          public          postgres    false    250            Q           0    0 %   tbTipoCobertura_id_tipo_cobertura_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."tbTipoCobertura_id_tipo_cobertura_seq"', 9, true);
          public          postgres    false    252            R           0    0 %   tbTipoReaseguro_id_tipo_reaseguro_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."tbTipoReaseguro_id_tipo_reaseguro_seq"', 2, true);
          public          postgres    false    253            S           0    0    tbTipoSeguro_id_tipo_seguro_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."tbTipoSeguro_id_tipo_seguro_seq"', 6, true);
          public          postgres    false    254            T           0    0 %   tbTipoSiniestro_id_tipo_siniestro_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."tbTipoSiniestro_id_tipo_siniestro_seq"', 8, true);
          public          postgres    false    255            U           0    0    tbUsuarios_id_usuario_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."tbUsuarios_id_usuario_seq"', 117, true);
          public          postgres    false    257            Q           2606    18021 J   tbAgenciaSeguro tbAgenciaSeguro_correo_electronico_correo_electronico1_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbAgenciaSeguro"
    ADD CONSTRAINT "tbAgenciaSeguro_correo_electronico_correo_electronico1_key" UNIQUE (correo_electronico) INCLUDE (correo_electronico);
 x   ALTER TABLE ONLY public."tbAgenciaSeguro" DROP CONSTRAINT "tbAgenciaSeguro_correo_electronico_correo_electronico1_key";
       public            postgres    false    234            S           2606    18023 $   tbAgenciaSeguro tbAgenciaSeguro_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."tbAgenciaSeguro"
    ADD CONSTRAINT "tbAgenciaSeguro_pkey" PRIMARY KEY (id_agencia_seguro);
 R   ALTER TABLE ONLY public."tbAgenciaSeguro" DROP CONSTRAINT "tbAgenciaSeguro_pkey";
       public            postgres    false    234            7           2606    18025 :   tbCliente tbCliente_carnet_identidad_carnet_identidad1_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "tbCliente_carnet_identidad_carnet_identidad1_key" UNIQUE (carnet_identidad) INCLUDE (carnet_identidad);
 h   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "tbCliente_carnet_identidad_carnet_identidad1_key";
       public            postgres    false    215            9           2606    18027 >   tbCliente tbCliente_correo_electronico_correo_electronico1_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "tbCliente_correo_electronico_correo_electronico1_key" UNIQUE (correo_electronico) INCLUDE (correo_electronico);
 l   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "tbCliente_correo_electronico_correo_electronico1_key";
       public            postgres    false    215            ;           2606    18029    tbCliente tbCliente_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "tbCliente_pkey" PRIMARY KEY (numero_identidad_cliente);
 F   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "tbCliente_pkey";
       public            postgres    false    215            M           2606    18031 ,   tbCompReaseguradora tbCompReaseguradora_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbCompReaseguradora"
    ADD CONSTRAINT "tbCompReaseguradora_pkey" PRIMARY KEY (id_comp_reaseguradora);
 Z   ALTER TABLE ONLY public."tbCompReaseguradora" DROP CONSTRAINT "tbCompReaseguradora_pkey";
       public            postgres    false    230            U           2606    18033 "   tbEstadoPoliza tbEstadoPoliza_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."tbEstadoPoliza"
    ADD CONSTRAINT "tbEstadoPoliza_pkey" PRIMARY KEY (id_estado_poliza);
 P   ALTER TABLE ONLY public."tbEstadoPoliza" DROP CONSTRAINT "tbEstadoPoliza_pkey";
       public            postgres    false    238            =           2606    18035 ,   tbEstadoReclamacion tbEstadoReclamacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbEstadoReclamacion"
    ADD CONSTRAINT "tbEstadoReclamacion_pkey" PRIMARY KEY (id_estado_reclamacion);
 Z   ALTER TABLE ONLY public."tbEstadoReclamacion" DROP CONSTRAINT "tbEstadoReclamacion_pkey";
       public            postgres    false    216            W           2606    18037 4   tbMotivoCancelacionPoliza tbMotivoRechazoPoliza_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbMotivoCancelacionPoliza"
    ADD CONSTRAINT "tbMotivoRechazoPoliza_pkey" PRIMARY KEY (numero_poliza);
 b   ALTER TABLE ONLY public."tbMotivoCancelacionPoliza" DROP CONSTRAINT "tbMotivoRechazoPoliza_pkey";
       public            postgres    false    241            Y           2606    18039 :   tbMotivoRechazoReclamacion tbMotivoRechazoReclamacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbMotivoRechazoReclamacion"
    ADD CONSTRAINT "tbMotivoRechazoReclamacion_pkey" PRIMARY KEY (numero_reclamacion);
 h   ALTER TABLE ONLY public."tbMotivoRechazoReclamacion" DROP CONSTRAINT "tbMotivoRechazoReclamacion_pkey";
       public            postgres    false    242            G           2606    18041 *   tbPais tbPais_nombre_pais_nombre_pais1_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbPais"
    ADD CONSTRAINT "tbPais_nombre_pais_nombre_pais1_key" UNIQUE (nombre_pais) INCLUDE (nombre_pais);
 X   ALTER TABLE ONLY public."tbPais" DROP CONSTRAINT "tbPais_nombre_pais_nombre_pais1_key";
       public            postgres    false    222            I           2606    18043    tbPais tbPais_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."tbPais"
    ADD CONSTRAINT "tbPais_pkey" PRIMARY KEY (id_pais);
 @   ALTER TABLE ONLY public."tbPais" DROP CONSTRAINT "tbPais_pkey";
       public            postgres    false    222            ?           2606    18045    tbPoliza tbPoliza_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "tbPoliza_pkey" PRIMARY KEY (numero_poliza);
 D   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "tbPoliza_pkey";
       public            postgres    false    217            [           2606    18047 2   tbPorcentParticipacion tbPorcentParticipacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbPorcentParticipacion"
    ADD CONSTRAINT "tbPorcentParticipacion_pkey" PRIMARY KEY (id_agencia_seguro, id_tipo_seguro, id_comp_reaseguradora);
 `   ALTER TABLE ONLY public."tbPorcentParticipacion" DROP CONSTRAINT "tbPorcentParticipacion_pkey";
       public            postgres    false    245    245    245            ]           2606    18049 "   tbPrimaMensual tbPrimaMensual_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."tbPrimaMensual"
    ADD CONSTRAINT "tbPrimaMensual_pkey" PRIMARY KEY (anno, mes, numero_poliza);
 P   ALTER TABLE ONLY public."tbPrimaMensual" DROP CONSTRAINT "tbPrimaMensual_pkey";
       public            postgres    false    247    247    247            A           2606    18051     tbReclamacion tbReclamacion_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."tbReclamacion"
    ADD CONSTRAINT "tbReclamacion_pkey" PRIMARY KEY (numero_reclamacion);
 N   ALTER TABLE ONLY public."tbReclamacion" DROP CONSTRAINT "tbReclamacion_pkey";
       public            postgres    false    218            _           2606    18053 *   tbSegurosDeAgencia tbSegurosDeAgencia_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."tbSegurosDeAgencia"
    ADD CONSTRAINT "tbSegurosDeAgencia_pkey" PRIMARY KEY (id_tipo_seguro, id_agencia_seguro);
 X   ALTER TABLE ONLY public."tbSegurosDeAgencia" DROP CONSTRAINT "tbSegurosDeAgencia_pkey";
       public            postgres    false    249    249            K           2606    18055    tbSexo tbSexo_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."tbSexo"
    ADD CONSTRAINT "tbSexo_pkey" PRIMARY KEY (id_sexo);
 @   ALTER TABLE ONLY public."tbSexo" DROP CONSTRAINT "tbSexo_pkey";
       public            postgres    false    224            a           2606    18057 $   tbTipoCobertura tbTipoCobertura_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."tbTipoCobertura"
    ADD CONSTRAINT "tbTipoCobertura_pkey" PRIMARY KEY (id_tipo_cobertura);
 R   ALTER TABLE ONLY public."tbTipoCobertura" DROP CONSTRAINT "tbTipoCobertura_pkey";
       public            postgres    false    251            O           2606    18059 $   tbTipoReaseguro tbTipoReaseguro_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."tbTipoReaseguro"
    ADD CONSTRAINT "tbTipoReaseguro_pkey" PRIMARY KEY (id_tipo_reaseguro);
 R   ALTER TABLE ONLY public."tbTipoReaseguro" DROP CONSTRAINT "tbTipoReaseguro_pkey";
       public            postgres    false    231            C           2606    18061    tbTipoSeguro tbTipoSeguro_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."tbTipoSeguro"
    ADD CONSTRAINT "tbTipoSeguro_pkey" PRIMARY KEY (id_tipo_seguro);
 L   ALTER TABLE ONLY public."tbTipoSeguro" DROP CONSTRAINT "tbTipoSeguro_pkey";
       public            postgres    false    219            E           2606    18063 $   tbTipoSiniestro tbTipoSiniestro_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."tbTipoSiniestro"
    ADD CONSTRAINT "tbTipoSiniestro_pkey" PRIMARY KEY (id_tipo_siniestro);
 R   ALTER TABLE ONLY public."tbTipoSiniestro" DROP CONSTRAINT "tbTipoSiniestro_pkey";
       public            postgres    false    220            c           2606    18065    tbUsuarios tbUsuarios_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."tbUsuarios"
    ADD CONSTRAINT "tbUsuarios_pkey" PRIMARY KEY (id_usuario);
 H   ALTER TABLE ONLY public."tbUsuarios" DROP CONSTRAINT "tbUsuarios_pkey";
       public            postgres    false    256            5           1259    18204 "   nombre_cliente_1726797670055_index    INDEX     d   CREATE INDEX nombre_cliente_1726797670055_index ON public."tbCliente" USING btree (nombre_cliente);
 6   DROP INDEX public.nombre_cliente_1726797670055_index;
       public            postgres    false    215                       2618    17929 8   salida_cliente_con_cantidad_reclamacion_aprobada _RETURN    RULE     O  CREATE OR REPLACE VIEW public.salida_cliente_con_cantidad_reclamacion_aprobada AS
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
       public          postgres    false    217    217    218    218    218    215    215    218    4923    227                       2618    17933 9   salida_cliente_con_cantidad_reclamacion_rechazada _RETURN    RULE       CREATE OR REPLACE VIEW public.salida_cliente_con_cantidad_reclamacion_rechazada AS
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
       public          postgres    false    218    218    217    215    217    215    4923    218    228            f           2606    18067    tbPoliza Cobertura_Poliza    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Cobertura_Poliza" FOREIGN KEY (id_tipo_cobertura) REFERENCES public."tbTipoCobertura"(id_tipo_cobertura) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Cobertura_Poliza";
       public          postgres    false    217    4961    251            g           2606    18072    tbPoliza Estado_Poliza    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Estado_Poliza" FOREIGN KEY (id_estado_poliza) REFERENCES public."tbEstadoPoliza"(id_estado_poliza) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 D   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Estado_Poliza";
       public          postgres    false    217    4949    238            k           2606    18077     tbReclamacion Estado_Reclamacion    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbReclamacion"
    ADD CONSTRAINT "Estado_Reclamacion" FOREIGN KEY (id_estado_reclamacion) REFERENCES public."tbEstadoReclamacion"(id_estado_reclamacion) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public."tbReclamacion" DROP CONSTRAINT "Estado_Reclamacion";
       public          postgres    false    216    4925    218            r           2606    18082 "   tbPorcentParticipacion PP_AgenciaS    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPorcentParticipacion"
    ADD CONSTRAINT "PP_AgenciaS" FOREIGN KEY (id_agencia_seguro) REFERENCES public."tbAgenciaSeguro"(id_agencia_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."tbPorcentParticipacion" DROP CONSTRAINT "PP_AgenciaS";
       public          postgres    false    4947    234    245            s           2606    18087    tbPorcentParticipacion PP_CompR    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPorcentParticipacion"
    ADD CONSTRAINT "PP_CompR" FOREIGN KEY (id_comp_reaseguradora) REFERENCES public."tbCompReaseguradora"(id_comp_reaseguradora) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 M   ALTER TABLE ONLY public."tbPorcentParticipacion" DROP CONSTRAINT "PP_CompR";
       public          postgres    false    4941    230    245            t           2606    18092    tbPorcentParticipacion PP_TipoS    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPorcentParticipacion"
    ADD CONSTRAINT "PP_TipoS" FOREIGN KEY (id_tipo_seguro) REFERENCES public."tbTipoSeguro"(id_tipo_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 M   ALTER TABLE ONLY public."tbPorcentParticipacion" DROP CONSTRAINT "PP_TipoS";
       public          postgres    false    4931    219    245            h           2606    18097    tbPoliza Poliza_AgenciaS    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Poliza_AgenciaS" FOREIGN KEY (id_agencia_seguro) REFERENCES public."tbAgenciaSeguro"(id_agencia_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Poliza_AgenciaS";
       public          postgres    false    234    4947    217            p           2606    18102 *   tbMotivoCancelacionPoliza Poliza_Cancelada    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbMotivoCancelacionPoliza"
    ADD CONSTRAINT "Poliza_Cancelada" FOREIGN KEY (numero_poliza) REFERENCES public."tbPoliza"(numero_poliza) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 X   ALTER TABLE ONLY public."tbMotivoCancelacionPoliza" DROP CONSTRAINT "Poliza_Cancelada";
       public          postgres    false    217    241    4927            i           2606    18107    tbPoliza Poliza_Cliente    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Poliza_Cliente" FOREIGN KEY (numero_identidad_cliente) REFERENCES public."tbCliente"(numero_identidad_cliente) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 E   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Poliza_Cliente";
       public          postgres    false    217    4923    215            j           2606    18112    tbPoliza Poliza_TipoSeguro    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPoliza"
    ADD CONSTRAINT "Poliza_TipoSeguro" FOREIGN KEY (id_tipo_seguro) REFERENCES public."tbTipoSeguro"(id_tipo_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 H   ALTER TABLE ONLY public."tbPoliza" DROP CONSTRAINT "Poliza_TipoSeguro";
       public          postgres    false    217    4931    219            d           2606    18117    tbCliente Procedencia_Cliente    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "Procedencia_Cliente" FOREIGN KEY (id_pais) REFERENCES public."tbPais"(id_pais) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 K   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "Procedencia_Cliente";
       public          postgres    false    215    4937    222            n           2606    18122 %   tbCompReaseguradora Procedencia_CompR    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbCompReaseguradora"
    ADD CONSTRAINT "Procedencia_CompR" FOREIGN KEY (id_pais) REFERENCES public."tbPais"(id_pais) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 S   ALTER TABLE ONLY public."tbCompReaseguradora" DROP CONSTRAINT "Procedencia_CompR";
       public          postgres    false    230    4937    222            l           2606    18127     tbReclamacion Reclamacion_Poliza    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbReclamacion"
    ADD CONSTRAINT "Reclamacion_Poliza" FOREIGN KEY (numero_poliza) REFERENCES public."tbPoliza"(numero_poliza) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public."tbReclamacion" DROP CONSTRAINT "Reclamacion_Poliza";
       public          postgres    false    218    4927    217            q           2606    18132 0   tbMotivoRechazoReclamacion Reclamacion_Rechazada    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbMotivoRechazoReclamacion"
    ADD CONSTRAINT "Reclamacion_Rechazada" FOREIGN KEY (numero_reclamacion) REFERENCES public."tbReclamacion"(numero_reclamacion) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 ^   ALTER TABLE ONLY public."tbMotivoRechazoReclamacion" DROP CONSTRAINT "Reclamacion_Rechazada";
       public          postgres    false    242    4929    218            m           2606    18137 $   tbReclamacion Reclamacion_TSiniestro    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbReclamacion"
    ADD CONSTRAINT "Reclamacion_TSiniestro" FOREIGN KEY (id_tipo_siniestro) REFERENCES public."tbTipoSiniestro"(id_tipo_siniestro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 R   ALTER TABLE ONLY public."tbReclamacion" DROP CONSTRAINT "Reclamacion_TSiniestro";
       public          postgres    false    218    220    4933            e           2606    18142    tbCliente Sexo_Cliente    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbCliente"
    ADD CONSTRAINT "Sexo_Cliente" FOREIGN KEY (id_sexo) REFERENCES public."tbSexo"(id_sexo) ON UPDATE SET NULL ON DELETE SET NULL NOT VALID;
 D   ALTER TABLE ONLY public."tbCliente" DROP CONSTRAINT "Sexo_Cliente";
       public          postgres    false    4939    224    215            o           2606    18147 '   tbCompReaseguradora TipoReaseguro_CompR    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbCompReaseguradora"
    ADD CONSTRAINT "TipoReaseguro_CompR" FOREIGN KEY (id_tipo_reaseguro) REFERENCES public."tbTipoReaseguro"(id_tipo_reaseguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 U   ALTER TABLE ONLY public."tbCompReaseguradora" DROP CONSTRAINT "TipoReaseguro_CompR";
       public          postgres    false    231    4943    230            u           2606    18152 0   tbPrimaMensual tbPrimaMensual_numero_poliza_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbPrimaMensual"
    ADD CONSTRAINT "tbPrimaMensual_numero_poliza_fkey" FOREIGN KEY (numero_poliza) REFERENCES public."tbPoliza"(numero_poliza) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 ^   ALTER TABLE ONLY public."tbPrimaMensual" DROP CONSTRAINT "tbPrimaMensual_numero_poliza_fkey";
       public          postgres    false    217    247    4927            v           2606    18157 <   tbSegurosDeAgencia tbSegurosDeAgencia_id_agencia_seguro_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbSegurosDeAgencia"
    ADD CONSTRAINT "tbSegurosDeAgencia_id_agencia_seguro_fkey" FOREIGN KEY (id_agencia_seguro) REFERENCES public."tbAgenciaSeguro"(id_agencia_seguro) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 j   ALTER TABLE ONLY public."tbSegurosDeAgencia" DROP CONSTRAINT "tbSegurosDeAgencia_id_agencia_seguro_fkey";
       public          postgres    false    234    4947    249            w           2606    18162 9   tbSegurosDeAgencia tbSegurosDeAgencia_id_tipo_seguro_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."tbSegurosDeAgencia"
    ADD CONSTRAINT "tbSegurosDeAgencia_id_tipo_seguro_fkey" FOREIGN KEY (id_tipo_seguro) REFERENCES public."tbTipoSeguro"(id_tipo_seguro) ON UPDATE CASCADE ON DELETE CASCADE;
 g   ALTER TABLE ONLY public."tbSegurosDeAgencia" DROP CONSTRAINT "tbSegurosDeAgencia_id_tipo_seguro_fkey";
       public          postgres    false    4931    219    249               �  x�u��n�0���S�	�̱�V#�6K$�N��1c��B��&O?.�Q�`@0�S�ǟ�u��`����F<��ҙ�@�2fsd=c��3Ve:�E�X��<�e@������W�k;26=Hk	��}e����{~���u�
�.�3���]�r�E	��#��
�,�sH�x�xCN���Y��Ȟg�6qƬH�Vm�墬f�*/�>ҌY�$�&T�d�^:�ڞ/�����*���aG6��Ə���?�ސ#����>q�զ�>�ꊶ����"�N�XN��yB���8�����6����w�����C�Q����ޢ�%Ԯe��u��B����=�嘕���a��#�ыS������N^uU��3��I	?�Bs�8��&I���         m  x�]��n�0���S���4I��`�l�ؑ��F4R���E����2iL>����O9��G���-	��f���c�A�]4�]/R��֜1�,TYeUU�����ԡ�i�;ȸ���9<Q���a@;�7XT�:�t�]}�̚��hQ
��Ĳ��#[��]N��ykz�:t�s��ZM�t�Ȃ��{�,
�8�����?:�\��Z�I��7�a�@ҲI8�v�A�0!R�7u;`M{gm%��4��b���D�K���O:���4�[sA�3�M�H�eB-��������99�\a�S׆Fa�;�`���[t��_♂p7|bσv>�����|��
���D�6>�iA��&I�⦦         ?   x�3�4�4��-�)�NMWp��-H̫�2�4J�&���%��%*x��yɩ\1z\\\ �uN         *   x�3�tN�KN�ILI�2�K�K���9�K2��b���� �V	�         .   x�3�t,(�OJLI�2�t�(�ON-��2�JM�H����qqq ���      !      x�34�t�IL#�=... /��      "   �   x�UN;rC!��)�)���M��<� "R���s�F�����Ndk��0�n�s�?é���Ű,N��R�a�;;��m�/Y�#}�E6��A�%?��%�/�����Wu��/(��c���>�"':s�NH��KY1�k�ܧk���d�Zg��XZV         m   x��1�0��W�'��X����B,r�ܡ8�?�ڑf6 �ǗQ�-���>�b���W�MMx�9o2y��M�ǭ��
��51�<���<t��T��{s>�$Ku L         �   x���]� ���.60��w���c�m��>lb��8��� ��W�3�w�΃&3)Wi��.����<0J��V�b�Y�ɖ.l����")a&4Cm�S�w�[=%7��/����f� ʸ�#������#��2W��~E�`<Z�
�D.k#���,IɌ+��2//�ϋ�L��8z���l�՜���9Zk_��LT      %   (   x�3�4�4�44�S�F�\�@� EL�"&f\1z\\\ l�(      '   &   x�34�4�4�420��26�00�4�L�b���� P��         K   x�E���0Cѳ�K�Dwa�9Hi%$�_�|C���L:�����c���1;�A�Z��3p5Ҵ���Y��h�af/:�      )   !   x�3�4�2�4�2b#0ې��M�8F��� C?�         8   x�3�tK�M�����2��M,N.���9�2��2�L8=�RR�2�2S�b���� ��X      +   (   x�3���2�(J��,��2�t-.I�KI,����� ��x         "   x�3���(�/�/J���K��2�D���qqq ��         1   x�3�t,-��2���OO,�2��LI�2�N�)M�2r�R�b���� �
�         d   x�M�;1���9�:�p�m��!���q8?���^n�I�X��(W�L���$�I� ��Vك)ϰ�>mm#Z1���=e:��k��h)��/�#�      0   �   x�]�Q�@���~Lt�f>JA !=���R'�n\���,H�m�[��Z/1�yٰ��t*���*x���Î�Qa]���D-5M�P]U��|�ڟ)6:%E�=�y�������[��&˾�h��kO2yN�a���t�����6K�     