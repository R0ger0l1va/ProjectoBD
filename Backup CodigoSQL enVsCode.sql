//CONSULTA 1

SELECT public."tbPoliza".numero_poliza, public."tbPoliza".fecha_inicio, public."tbPoliza".fecha_fin, public."tbPoliza".prima_mensual, public."tbPoliza".monto_total_asegurado, 
	   public."tbCliente".nombre_cliente, public."tbCliente".apellido_cliente,
	   public."tbEstadoPoliza".nombre_estado_poliza
FROM public."tbPoliza", public."tbCliente", public."tbEstadoPoliza"
WHERE public."tbPoliza".numero_identidad_cliente = public."tbCliente".numero_identidad_cliente AND 
		public."tbPoliza".id_estado_poliza = public."tbEstadoPoliza".id_estado_poliza
ORDER BY numero_poliza ASC 

//CONSULTA 2 (INNERJOIN)

SELECT public."tbPoliza".numero_poliza, public."tbPoliza".fecha_inicio, public."tbPoliza".fecha_fin, public."tbPoliza".prima_mensual, public."tbPoliza".monto_total_asegurado, 
	   public."tbCliente".nombre_cliente, public."tbCliente".apellido_cliente,
	   public."tbEstadoPoliza".nombre_estado_poliza
FROM public."tbPoliza", public."tbCliente", public."tbEstadoPoliza"
WHERE public."tbPoliza".numero_identidad_cliente = public."tbCliente".numero_identidad_cliente AND 
		public."tbPoliza".id_estado_poliza = public."tbEstadoPoliza".id_estado_poliza AND
		public."tbPoliza".numero_identidad_cliente = 1
ORDER BY numero_poliza ASC 




//REPORTE ESPECIFICO 1:

CREATE OR REPLACE FUNCTION obtener_Agencia_dadoID(p_id_agencia_seguro integer)
RETURNS TABLE(id_agencia_seguro INTEGER, nombre_agencia_seguro VARCHAR,direccion_postal VARCHAR, telefono VARCHAR, correo_electronico VARCHAR, 
			   nombre_director_general VARCHAR, nombre_jefe_departamento_seguros VARCHAR, nombre_jefe_departamento_reclamaciones VARCHAR) AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbAgenciaSeguro".id_agencia_seguro , public."tbAgenciaSeguro".nombre_agencia_seguro ,
	       public."tbAgenciaSeguro".direccion_postal , public."tbAgenciaSeguro".telefono , 
	       public."tbAgenciaSeguro".correo_electronico , public."tbAgenciaSeguro".nombre_director_general , 
		   public."tbAgenciaSeguro".nombre_jefe_departamento_seguros , public."tbAgenciaSeguro".nombre_jefe_departamento_reclamaciones
	FROM public."tbAgenciaSeguro"
    WHERE public."tbAgenciaSeguro".id_agencia_seguro = p_id_agencia_seguro;
END;
$$ LANGUAGE plpgsql;

//REPORTE ESPECIFICO 2:
	//Funcion 1
	CREATE OR REPLACE FUNCTION obtener_cliente_dadoid (p_numero_identidad_cliente INTEGER)
RETURNS TABLE (nombre_cliente VARCHAR, numero_identidad_cliente INTEGER, 
telefono VARCHAR, direccion_postal VARCHAR, correo_electronico VARCHAR) AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbCliente".nombre_cliente, public."tbCliente".numero_identidad_cliente,
			public."tbCliente".telefono, public."tbCliente".direccion_postal, 
			public."tbCliente".correo_electronico
	 FROM public."tbCliente"
	 WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
END;
$$ LANGUAGE plpgsql;

	//Funcion 2
CREATE OR REPLACE FUNCTION obtener_polizas_activas_cantidad_dadoCliente(p_numero_identidad_cliente INTEGER)
RETURNS TABLE(numero_poliza INTEGER, contador INTEGER) AS $$
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
$$ LANGUAGE plpgsql;


	//Funcion 3
	CREATE OR REPLACE FUNCTION obtener_valor_total_primas_dado_poliza(p_numero_poliza INTEGER)
RETURNS DOUBLE PRECISION AS $$
DECLARE resultado DOUBLE PRECISION;
BEGIN
	SELECT SUM(monto_pagado) INTO resultado
	FROM public."tbPrimaMensual" 
	WHERE public."tbPrimaMensual".numero_poliza = p_numero_poliza;
	RETURN resultado;
END;
$$ LANGUAGE plpgsql;

	//Funcion 4
	CREATE OR REPLACE FUNCTION obtener_reclamaciones_dado_polizaid(p_numero_poliza INTEGER)
RETURNS TABLE (numero_reclamacion INTEGER, numero_poliza INTEGER, id_estado_reclamacion INTEGER,
id_tipo_siniestro INTEGER, fecha_siniestro DATE, monto_reclamado DOUBLE PRECISION, 
monto_indemnizado DOUBLE PRECISION) AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbReclamacion".numero_reclamacion, public."tbReclamacion".numero_poliza, 
		   public."tbReclamacion".id_estado_reclamacion, public."tbReclamacion".id_tipo_siniestro, 
		   public."tbReclamacion".fecha_siniestro , public."tbReclamacion".monto_reclamado, 
		   public."tbReclamacion".monto_indemnizado 
	FROM public."tbReclamacion" 
	WHERE public."tbReclamacion".numero_poliza = p_numero_poliza;
END;
$$ LANGUAGE plpgsql;


//REPORTE ESPECIFICO 3:
 //Funcion 1
CREATE OR REPLACE FUNCTION obtener_CompRe_dadoID(p_id_aReaseguradora integer)
RETURNS TABLE(nombre_compannia_reaseguradora VARCHAR, 
		nombre_pais VARCHAR, nombre_tipo_reaseguro VARCHAR) AS $$
BEGIN
	RETURN QUERY
	SELECT 
		public."tbCompReaseguradora".nombre_compannia_reaseguradora, 
		public."tbpais".nombre_pais, public."tbTipoReaseguro".nombre_tipo_reaseguro
	FROM 
		public."tbCompReaseguradora", public."tbpais", public."tbTipoReaseguro"
	WHERE 
		public."tbCompReaseguradora".id_pais = public."tbpais".id_pais AND 
		public."tbCompReaseguradora".id_tipo_reaseguro = public."tbTipoReaseguro".id_tipo_reaseguro AND
		public."tbCompReaseguradora".id_comp_reaseguradora = p_id_aReaseguradora;
END;
$$ LANGUAGE plpgsql;

 //Funcion 2
CREATE OR REPLACE FUNCTION obtener_pParticipacion_dado_idAgen_idCompRe(p_id_comp_reaseguradora integer,
																			   p_id_agencia integer)
RETURNS TABLE(nombre_tipo_seguro VARCHAR, porciento_participacion DOUBLE PRECISION) AS $$
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
$$ LANGUAGE plpgsql;

//REPORTE ESPECIFICO 4:
	CREATE OR REPLACE FUNCTION obtener_polizas_emitidas_dado_periodo_tiempo(p_fecha_inicio DATE,p_fecha_fin DATE)
RETURNS TABLE (numero_poliza INTEGER, nombre_cliente VARCHAR,
				nombre_tipo_seguro VARCHAR, fecha_incio DATE, fecha_fin DATE, 
				prima_mensual DOUBLE PRECISION,
				nombre_estado_poliza VARCHAR) AS $$
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
$$ LANGUAGE plpgsql;
			   
			   
//REPORTE ESPECIFICO 5 (vista): 
 //es una vista pq me dice el reporte de estado de todas las reclamaciones
SELECT 
	public."tbReclamacion".numero_reclamacion,public."tbCliente".nombre_cliente, 
	public."tbReclamacion".numero_poliza,public."tbTipoSeguro".nombre_tipo_seguro, 
	public."tbTipoSiniestro".nombre_siniestro, public."tbEstadoReclamacion".nombre_estado_reclamacion, 
	public."tbReclamacion".fecha_siniestro,public."tbReclamacion".monto_reclamado, 
	public."tbReclamacion".monto_indemnizado
FROM 
	public."tbReclamacion", public."tbTipoSiniestro", public."tbTipoSeguro",public."tbCliente", public."tbEstadoReclamacion"
WHERE 
	public."tbReclamacion".id_tipo_siniestro =  public."tbTipoSiniestro".id_tipo_siniestro AND 
	public."tbTipoSeguro".id_tipo_seguro IN (SELECT 
											 	public."tbPoliza".id_tipo_seguro 
											 FROM 
											 	public."tbPoliza" 
											 WHERE 
											 	public."tbPoliza".numero_poliza = public."tbReclamacion".numero_poliza) AND
    public."tbCliente".numero_identidad_cliente IN (SELECT
														 public."tbPoliza".numero_identidad_cliente
												     FROM
														 public."tbPoliza"
													 WHERE 
														 public."tbPoliza".numero_poliza = public."tbReclamacion".numero_poliza) AND
    public."tbReclamacion".id_estado_reclamacion = public."tbEstadoReclamacion".id_estado_reclamacion
ORDER BY public."tbEstadoReclamacion".nombre_estado_reclamacion ASC

//REPORTE ESPECIFICO 6:
 CREATE OR REPLACE FUNCTION obtener_ingresos_mensuales_por_concepto_primas_dado_anno(p_anno INTEGER)
RETURNS TABLE(anno INTEGER, mes INTEGER, monto_pagado DOUBLE PRECISION) AS $$
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
$$ LANGUAGE plpgsql;









(C)INSERT //solo funciona si vas a annadir una tupla completa, es todo o nada y hay que especificar todos los caampos/atributos de la tupla
		CREATE OR REPLACE FUNCTION tbpais_insert(p_nombre_pais VARCHAR)
	RETURNS TABLE(id_pais INTEGER, nombre_pais VARCHAR) AS $$
	BEGIN
		INSERT INTO public."tbpais" (nombre_pais) VALUES (p_nombre_pais);
		RETURN QUERY
		SELECT public."tbpais".id_pais, public."tbpais".nombre_pais
		FROM public."tbpais"
		WHERE public."tbpais".nombre_pais = p_nombre_pais;
	END;
	$$ LANGUAGE plpgsql;
			   
			   
(R)READ
			CREATE OR REPLACE FUNCTION tbpais_read(p_id_pais INTEGER)
	RETURNS TABLE(id_pais INTEGER, nombre_pais VARCHAR) AS $$
	BEGIN
		RETURN QUERY
		SELECT public."tbpais".id_pais, public."tbpais".nombre_pais  
		FROM public."tbpais"
		WHERE public."tbpais".id_pais = p_id_pais;
	END;
	$$ LANGUAGE plpgsql;
			   
			   
(U)UPDATE //para actualizar o modificar un valor de un campo/atributo de la tupla
	CREATE OR REPLACE FUNCTION tbpais_update(p_id_pais INTEGER,p_nombre_pais VARCHAR)
	RETURNS TABLE(id_pais INTEGER, nombre_pais VARCHAR) AS $$
	BEGIN

		UPDATE 
			public."tbpais" 
		SET 
			nombre_pais = p_nombre_pais 
		WHERE 
			public."tbpais".id_pais = p_id_pais;
		RETURN QUERY
		SELECT public."tbpais".id_pais, public."tbpais".nombre_pais
		FROM public."tbpais"
		WHERE public."tbpais".id_pais = p_id_pais;
	END;
	$$ LANGUAGE plpgsql;
			   
			   
(D)DELETE
		CREATE OR REPLACE FUNCTION tbpais_delete(p_id_pais INTEGER)
	RETURNS BOOL  AS $$
	DECLARE resultado bool;
	BEGIN
		resultado := true;
		BEGIN 
			DELETE FROM public."tbpais" WHERE public."tbpais".id_pais = p_id_pais;
			EXCEPTION WHEN NO_DATA_FOUND THEN resultado := false;
		END;
		RETURN resultado;
	END;
	$$ LANGUAGE plpgsql;
			   
			   
CRUD
tbCliente
R:
	CREATE OR REPLACE FUNCTION tbCliente_read(p_numero_identidad_cliente INTEGER)
	RETURNS TABLE(numero_identidad_cliente INTEGER, id_pais INTEGER, id_sexo INTEGER, 
				nombre_cliente VARCHAR, apellido_cliente VARCHAR, edad INTEGER, 
				direccion_postal VARCHAR, telefono VARCHAR, correo_electronico VARCHAR, carnet_identidad VARCHAR)  AS $$
	BEGIN
			RETURN QUERY
			SELECT *
			FROM public."tbCliente"
			WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
	END;
	$$ LANGUAGE plpgsql;
U:
	CREATE OR REPLACE FUNCTION tbCliente_update(p_numero_identidad_cliente INTEGER,p_id_pais INTEGER, 
											p_id_sexo INTEGER, 
											p_nombre_cliente VARCHAR, 
											p_apellido_cliente VARCHAR, 
											p_edad INTEGER, 
											p_direccion_postal VARCHAR, 
											p_telefono VARCHAR, p_correo_electronico VARCHAR, 
											p_carnet_identidad VARCHAR)
	RETURNS TABLE(numero_identidad_cliente INTEGER, id_pais INTEGER, id_sexo INTEGER, 
				nombre_cliente VARCHAR, apellido_cliente VARCHAR, edad INTEGER, 
				direccion_postal VARCHAR, telefono VARCHAR, correo_electronico VARCHAR, carnet_identidad VARCHAR)  AS $$
	BEGIN
			UPDATE public."tbCliente" 
			SET id_pais= p_id_pais , id_sexo= p_id_sexo, nombre_cliente= p_nombre_cliente, apellido_cliente= p_apellido_cliente, edad= p_edad, direccion_postal= p_direccion_postal, telefono= p_telefono , correo_electronico= p_correo_electronico, carnet_identidad= p_carnet_identidad
			WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
			RETURN QUERY
			SELECT *
			FROM public."tbCliente"
			WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
	END;
	$$ LANGUAGE plpgsql;

D:
	CREATE OR REPLACE FUNCTION tbCliente_delete(p_numero_identidad_cliente INTEGER)
	RETURNS BOOL  AS $$
	DECLARE resultado bool;
	BEGIN
			resultado:= true;
			BEGIN
				DELETE FROM public."tbCliente" 
				WHERE public."tbCliente".numero_identidad_cliente = p_numero_identidad_cliente;
			END;
			RETURN resultado;
	END;
	$$ LANGUAGE plpgsql;
				
tbAgenciaSeguro
C:
	CREATE OR REPLACE FUNCTION tbAgenciaSeguro_insert(p_nombre_agencia_seguro VARCHAR, p_direccion_postal VARCHAR, p_telefono VARCHAR, p_correo_electronico VARCHAR, p_nombre_director_general VARCHAR, p_nombre_jefe_departamento_seguros VARCHAR, p_nombre_jefe_departamento_reclamaciones VARCHAR )
	RETURNS TABLE (id_agencia_seguro INTEGER, nombre_agencia_seguro VARCHAR,direccion_postal VARCHAR, telefono VARCHAR, correo_electronico VARCHAR,nombre_director_general VARCHAR, nombre_jefe_departamento_seguros VARCHAR, nombre_jefe_departamento_reclamaciones VARCHAR)  AS $$

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
	$$ LANGUAGE plpgsql;
			   
R:
	CREATE OR REPLACE FUNCTION tbAgenciaSeguro_read(p_id_agencia_seguro INTEGER)
	RETURNS TABLE (id_agencia_seguro INTEGER, nombre_agencia_seguro VARCHAR,direccion_postal VARCHAR, telefono VARCHAR, correo_electronico VARCHAR,nombre_director_general VARCHAR, nombre_jefe_departamento_seguros VARCHAR, nombre_jefe_departamento_reclamaciones VARCHAR)  AS $$

	BEGIN
			RETURN QUERY
			SELECT public."tbAgenciaSeguro".id_agencia_seguro, public."tbAgenciaSeguro".nombre_agencia_seguro ,public."tbAgenciaSeguro".direccion_postal , public."tbAgenciaSeguro".telefono , 
				public."tbAgenciaSeguro".correo_electronico ,public."tbAgenciaSeguro".nombre_director_general ,
				public."tbAgenciaSeguro".nombre_jefe_departamento_seguros , 
				public."tbAgenciaSeguro".nombre_jefe_departamento_reclamaciones 
			FROM public."tbAgenciaSeguro" 
			WHERE public."tbAgenciaSeguro".id_agencia_seguro=p_id_agencia_seguro;
	END;
	$$ LANGUAGE plpgsql;
U:
	CREATE OR REPLACE FUNCTION tbAgenciaSeguro_update(p_id_agencia_seguro INTEGER,p_nombre_agencia_seguro VARCHAR, p_direccion_postal VARCHAR, p_telefono VARCHAR, p_correo_electronico VARCHAR, p_nombre_director_general VARCHAR, p_nombre_jefe_departamento_seguros VARCHAR, p_nombre_jefe_departamento_reclamaciones VARCHAR)
	RETURNS TABLE (id_agencia_seguro INTEGER, nombre_agencia_seguro VARCHAR,direccion_postal VARCHAR, telefono VARCHAR, correo_electronico VARCHAR,nombre_director_general VARCHAR, nombre_jefe_departamento_seguros VARCHAR, nombre_jefe_departamento_reclamaciones VARCHAR)  AS $$
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
	$$ LANGUAGE plpgsql;
			   
D:
	RETURNS BOOL AS $$
	DECLARE resultado bool;
	BEGIN
			resultado:= true;
			BEGIN
			DELETE FROM public."tbAgenciaSeguro" 
			WHERE public."tbAgenciaSeguro".id_agencia_seguro = p_id_agencia_seguro;
			END;
			RETURN resultado;
	END;
	$$ LANGUAGE plpgsql;
			   		   
tbCompReaseguradora
C:
	CREATE OR REPLACE FUNCTION tbCompReaseguradora_insert(p_id_pais INTEGER, p_id_tipo_reaseguro INTEGER, p_nombre_compannia_reaseguradora VARCHAR)
	RETURNS TABLE (id_comp_reaseguradora INTEGER, id_pais INTEGER, id_tipo_reaseguro INTEGER, nombre_compannia_reaseguradora VARCHAR) AS $$
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
	$$ LANGUAGE plpgsql;
R:
	CREATE OR REPLACE FUNCTION tbCompReaseguradora_read(p_id_comp_reaseguradora INTEGER)
	RETURNS TABLE (id_comp_reaseguradora INTEGER, id_pais INTEGER, id_tipo_reaseguro INTEGER, nombre_compannia_reaseguradora VARCHAR) AS $$
	BEGIN
			RETURN QUERY
			SELECT public."tbCompReaseguradora".id_comp_reaseguradora,
				public."tbCompReaseguradora".id_pais , 
				public."tbCompReaseguradora".id_tipo_reaseguro , 
				public."tbCompReaseguradora".nombre_compannia_reaseguradora
			FROM public."tbCompReaseguradora" 
			WHERE public."tbCompReaseguradora".id_comp_reaseguradora = p_id_comp_reaseguradora ;
	END;
	$$ LANGUAGE plpgsql;
			   
U:
	CREATE OR REPLACE FUNCTION tbCompReaseguradora_update(p_id_comp_reaseguradora INTEGER, p_id_pais INTEGER, p_id_tipo_reaseguro INTEGER, p_nombre_compannia_reaseguradora VARCHAR)
	RETURNS TABLE (id_comp_reaseguradora INTEGER, id_pais INTEGER, id_tipo_reaseguro INTEGER, nombre_compannia_reaseguradora VARCHAR) AS $$
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
	$$ LANGUAGE plpgsql;
				
D:
	CREATE OR REPLACE FUNCTION tbCompReaseguradora_delete(p_id_comp_reaseguradora INTEGER)
	RETURNS BOOL AS $$
	DECLARE resultado bool;
	BEGIN
			resultado:= true;
			BEGIN
			DELETE FROM public."tbCompReaseguradora" 
			WHERE public."tbCompReaseguradora".id_comp_reaseguradora = p_id_comp_reaseguradora; 
			END;
			RETURN resultado;
	END;
	$$ LANGUAGE plpgsql;

tbMotiivoCancelacionPoliza
C: CREATE OR REPLACE FUNCTION tbMotivoCancelacionPoliza_insert(p_numero_poliza INTEGER, 
															p_descripcion_motivo TEXT)
RETURNS TABLE (numero_poliza INTEGER, descripcion_motivo TEXT) AS $$
BEGIN
		INSERT INTO public."tbMotivoCancelacionPoliza" (numero_poliza, descripcion_motivo) 
		VALUES (p_numero_poliza, p_descripcion_motivo);
		RETURN QUERY
		SELECT public."tbMotivoCancelacionPoliza".numero_poliza, 
		public."tbMotivoCancelacionPoliza".descripcion_motivo
		FROM public."tbMotivoCancelacionPoliza"
		WHERE public."tbMotivoCancelacionPoliza".numero_poliza=p_numero_poliza;
END;
$$ LANGUAGE plpgsql;



U:
CREATE OR REPLACE FUNCTION tbMotivoCancelacionPoliza_update(p_numero_poliza INTEGER, 
															p_descripcion_motivo TEXT)
RETURNS TABLE (numero_poliza INTEGER, descripcion_motivo TEXT) AS $$
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
$$ LANGUAGE plpgsql;

D:
CREATE OR REPLACE FUNCTION tbMotivoCancelacionPoliza_delete(p_numero_poliza INTEGER)
RETURNS BOOL AS $$
DECLARE resultado BOOL;
BEGIN
		resultado:= true;
		BEGIN
		DELETE FROM public."tbMotivoCancelacionPoliza" 
		WHERE public."tbMotivoCancelacionPoliza".numero_poliza = p_numero_poliza;
		END;
		RETURN resultado;
		END;
$$ LANGUAGE plpgsql;

tbMotivoRechazoReclamacion
//CRUD muy parecido al de tbMotiivoCancelacionPoliza


tbPoliza
C:
	CREATE OR REPLACE FUNCTION tbPoliza_insert(p_id_agencia_seguro INTEGER, 
											p_numero_identidad_cliente INTEGER,
											p_id_estado_poliza INTEGER, 
											p_id_tipo_seguro INTEGER,  
											p_fecha_inicio DATE, 
											p_fecha_fin DATE, 
											p_prima_mensual REAL,
											p_monto_total_asegurado REAL, 
											p_id_tipo_cobertura INTEGER)
	RETURNS TABLE (numero_poliza INTEGER, id_agencia_seguro INTEGER, 
				numero_identidad_cliente INTEGER, id_estado_poliza INTEGER, 
				id_tipo_seguro INTEGER, fecha_inicio DATE, fecha_fin DATE, 
				prima_mensual REAL, monto_total_asegurado REAL,id_tipo_cobertura INTEGER) AS $$
	BEGIN
			INSERT INTO public."tbPoliza" (id_agencia_seguro , numero_identidad_cliente , id_estado_poliza, 
				id_tipo_seguro , fecha_inicio , fecha_fin , 
				prima_mensual , monto_total_asegurado, id_tipo_cobertura) 
			VALUES (p_id_agencia_seguro, p_numero_identidad_cliente,
					p_id_estado_poliza, p_id_tipo_seguro,
					p_fecha_inicio, p_fecha_fin, p_prima_mensual,
					p_monto_total_asegurado, p_id_tipo_cobertura);
	END;
	$$ LANGUAGE plpgsql;
U:
	CREATE OR REPLACE FUNCTION tbPoliza_update(p_numero_poliza INTEGER,
											p_id_agencia_seguro INTEGER, 
											p_numero_identidad_cliente INTEGER,
											p_id_estado_poliza INTEGER, 
											p_id_tipo_seguro INTEGER,  
											p_fecha_inicio DATE, 
											p_fecha_fin DATE, 
											p_prima_mensual REAL,
											p_monto_total_asegurado REAL, 
											p_id_tipo_cobertura INTEGER)
	RETURNS TABLE (numero_poliza INTEGER, id_agencia_seguro INTEGER, 
				numero_identidad_cliente INTEGER, id_estado_poliza INTEGER, 
				id_tipo_seguro INTEGER, fecha_inicio DATE, fecha_fin DATE, 
				prima_mensual REAL, monto_total_asegurado REAL,id_tipo_cobertura INTEGER) AS $$
	BEGIN
			UPDATE public."tbPoliza" 
			SET id_agencia_seguro=p_id_agencia_seguro , numero_identidad_cliente=p_numero_identidad_cliente , 
				id_estado_poliza=p_id_estado_poliza,
				id_tipo_seguro=p_id_tipo_seguro , fecha_inicio=p_fecha_inicio , fecha_fin=p_fecha_fin , 
				prima_mensual=p_prima_mensual , monto_total_asegurado=p_monto_total_asegurado, 
				id_tipo_cobertura=p_id_tipo_cobertura
				WHERE public."tbPoliza".numero_poliza = p_numero_poliza;
	END;
	$$ LANGUAGE plpgsql;
				
R:
	CREATE OR REPLACE FUNCTION tbPoliza_read(p_numero_poliza INTEGER)
	RETURNS TABLE (numero_poliza INTEGER, id_agencia_seguro INTEGER, 
				numero_identidad_cliente INTEGER, id_estado_poliza INTEGER, 
				id_tipo_seguro INTEGER, fecha_inicio DATE, fecha_fin DATE, 
				prima_mensual DOUBLE PRECISION, monto_total_asegurado DOUBLE PRECISION,id_tipo_cobertura INTEGER) AS $$
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
	$$ LANGUAGE plpgsql;
				
			   
D:
	CREATE OR REPLACE FUNCTION tbPoliza_delete(p_numero_poliza INTEGER)
	RETURNS BOOL AS $$
	DECLARE resultado bool;
	BEGIN
			resultado := true;
			BEGIN
				DELETE FROM public."tbPoliza" 
				WHERE public."tbPoliza".numero_poliza = p_numero_poliza;  
			END;
			RETURN resultado;
	END;
	$$ LANGUAGE plpgsql;
			   
tbPorcentParticipacion
C:
	CREATE OR REPLACE FUNCTION tbPorcentParticipacion_insert(p_id_agencia_seguro INTEGER, 
														p_id_tipo_seguro INTEGER, 
														p_id_comp_reaseguradora INTEGER,
														p_porciento_participacion DOUBLE PRECISION)
	RETURNS TABLE (id_agencia_seguro INTEGER, id_tipo_seguro INTEGER, id_comp_reaseguradora INTEGER, porciento_participacion DOUBLE PRECISION) AS $$
	BEGIN
		INSERT INTO public."tbPorcentParticipacion" (id_agencia_seguro , id_tipo_seguro , id_comp_reaseguradora , porciento_participacion)
		VALUES (p_id_agencia_seguro , p_id_tipo_seguro, p_id_comp_reaseguradora, p_porciento_participacion);
	END;
	$$ LANGUAGE plpgsql;
R:
	CREATE OR REPLACE FUNCTION tbPorcentParticipacion_read(p_id_agencia_seguro INTEGER, 
														p_id_tipo_seguro INTEGER, 
														p_id_comp_reaseguradora INTEGER)
	RETURNS TABLE (id_agencia_seguro INTEGER, id_tipo_seguro INTEGER, id_comp_reaseguradora INTEGER, porciento_participacion DOUBLE PRECISION) AS $$
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
	$$ LANGUAGE plpgsql;
			   
			   

U:
	CREATE OR REPLACE FUNCTION tbPorcentParticipacion_update(p_id_agencia_seguro INTEGER, 
														p_id_tipo_seguro INTEGER, 
														p_id_comp_reaseguradora INTEGER,
														p_porciento_participacion DOUBLE PRECISION)
	RETURNS TABLE (id_agencia_seguro INTEGER, id_tipo_seguro INTEGER, id_comp_reaseguradora INTEGER, porciento_participacion DOUBLE PRECISION) AS $$
	BEGIN
		UPDATE public."tbPorcentParticipacion" SET porciento_participacion = p_porciento_participacion 
		WHERE public."tbPorcentParticipacion".id_agencia_seguro=p_id_agencia_seguro AND
		public."tbPorcentParticipacion".id_tipo_seguro=p_id_tipo_seguro AND
		public."tbPorcentParticipacion".id_comp_reaseguradora=p_id_comp_reaseguradora ;
	END;
	$$ LANGUAGE plpgsql;
D:
CREATE OR REPLACE FUNCTION tbPorcentParticipacion_delete(p_id_agencia_seguro INTEGER, 
													   p_id_tipo_seguro INTEGER, 
													   p_id_comp_reaseguradora INTEGER)
RETURNS BOOL AS $$
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
$$ LANGUAGE plpgsql;


tbPrimaMensual			   
D:
	CREATE OR REPLACE FUNCTION tbPrimaMensual_delete(p_numero_poliza INTEGER, p_fecha_pago DATE)
	RETURNS BOOL AS $$
	DECLARE resultado bool;
	BEGIN
		resultado := true;
		BEGIN
			DELETE FROM public."tbPrimaMensual" 
			WHERE public."tbPrimaMensual".numero_poliza= p_numero_poliza AND 
			public."tbPrimaMensual".fecha_pago= p_fecha_pago;
		END;
		RETURN resultado;
	END;
	$$ LANGUAGE plpgsql;

tbReclamacion
C:
	CREATE OR REPLACE FUNCTION tbReclamacion_insert(p_numero_poliza INTEGER, p_id_estado_reclamacion INTEGER, 
													p_id_tipo_siniestro INTEGER, p_fecha_siniestro DATE, 
													p_monto_reclamado DOUBLE PRECISION, p_monto_indemnizado DOUBLE PRECISION)
	RETURNS TABLE (numero_reclamacion INTEGER ,numero_poliza INTEGER, id_estado_reclamacion INTEGER, 
				id_tipo_siniestro INTEGER,fecha_siniestro DATE, 
				monto_reclamado DOUBLE PRECISION, monto_indemnizado DOUBLE PRECISION) AS $$
	BEGIN  
		INSERT INTO public."tbReclamacion" (numero_poliza, id_estado_reclamacion, 
											id_tipo_siniestro, fecha_siniestro , 
											monto_reclamado, monto_indemnizado) 
		VALUES (p_numero_poliza , p_id_estado_reclamacion, p_id_tipo_siniestro, 
				p_fecha_siniestro, p_monto_reclamado, p_monto_indemnizado);
	END;
	$$ LANGUAGE plpgsql;

R:
	CREATE OR REPLACE FUNCTION tbReclamacion_read(p_numero_reclamacion INTEGER)
	RETURNS TABLE (numero_reclamacion INTEGER ,numero_poliza INTEGER, id_estado_reclamacion INTEGER, 
				id_tipo_siniestro INTEGER,fecha_siniestro DATE, 
				monto_reclamado DOUBLE PRECISION, monto_indemnizado DOUBLE PRECISION) AS $$
	BEGIN
		RETURN QUERY
		SELECT public."tbReclamacion".numero_reclamacion, public."tbReclamacion".numero_poliza, public."tbReclamacion".id_estado_reclamacion, 
			public."tbReclamacion".id_tipo_siniestro, public."tbReclamacion".fecha_siniestro, 
			public."tbReclamacion".monto_reclamado, public."tbReclamacion".monto_indemnizado 
		FROM public."tbReclamacion"
		WHERE public."tbReclamacion".numero_reclamacion=p_numero_reclamacion;
	END;
	$$ LANGUAGE plpgsql;
				
				

U:
	CREATE OR REPLACE FUNCTION tbReclamacion_update(p_numero_reclamacion INTEGER,p_numero_poliza INTEGER, p_id_estado_reclamacion INTEGER, 
													p_id_tipo_siniestro INTEGER, p_fecha_siniestro DATE, 
													p_monto_reclamado DOUBLE PRECISION, p_monto_indemnizado DOUBLE PRECISION)
	RETURNS TABLE (numero_reclamacion INTEGER ,numero_poliza INTEGER, id_estado_reclamacion INTEGER, 
				id_tipo_siniestro INTEGER,fecha_siniestro DATE, 
				monto_reclamado DOUBLE PRECISION, monto_indemnizado DOUBLE PRECISION) AS $$
	BEGIN  
		UPDATE public."tbReclamacion" SET numero_poliza=p_numero_poliza, id_estado_reclamacion=p_id_estado_reclamacion, 
											id_tipo_siniestro=p_id_tipo_siniestro, fecha_siniestro=p_fecha_siniestro , 
											monto_reclamado=p_monto_reclamado, monto_indemnizado=p_monto_indemnizado 
		WHERE public."tbReclamacion".numero_reclamacion=p_numero_reclamacion;
	END;
	$$ LANGUAGE plpgsql;
			   
D:
	CREATE OR REPLACE FUNCTION tbReclamacion_delete(p_numero_reclamacion INTEGER)
	RETURNS  BOOL AS $$
	DECLARE resultado bool;
	BEGIN
		resultado := true;
		BEGIN
			DELETE FROM public."tbReclamacion" 	WHERE public."tbReclamacion".numero_reclamacion=p_numero_reclamacion;
		END;
		RETURN resultado;
	END;
	$$ LANGUAGE plpgsql;
				
tbSexo //Solo le hice un read para poder visualizar su contenido
R:
CREATE OR REPLACE FUNCTION tbSexo_read(p_id_sexo INTEGER)
RETURNS  TABLE(id_sexo INTEGER, nombre_sexo VARCHAR) AS $$
BEGIN
	RETURN QUERY
	SELECT public."tbSexo".id_sexo, public."tbSexo".nombre_sexo
	FROM public."tbSexo"
	WHERE public."tbSexo".id_sexo = p_id_sexo;
END;
$$ LANGUAGE plpgsql;
			   
tbSegurosDeAgencia //no tiene update pq son dos llaves foraneas que a la vez fungen como llaves primarias 

R:// en este read hice un INNERJOIN para conectar el nombre de los tipos de seguro con el identificador de la agencia de seguro
	CREATE OR REPLACE FUNCTION tbSegurosDeAgencia_read(p_id_agencia_seguro INTEGER )
	RETURNS  TABLE(nombre_tipo_seguro VARCHAR, id_agencia_seguro INTEGER) AS $$
	BEGIN
		RETURN QUERY
		SELECT public."tbTipoSeguro".nombre_tipo_seguro, public."tbSegurosDeAgencia".id_agencia_seguro 
		FROM public."tbSegurosDeAgencia", public."tbTipoSeguro"
		WHERE public."tbSegurosDeAgencia".id_agencia_seguro= p_id_agencia_seguro AND
			public."tbSegurosDeAgencia".id_tipo_seguro= public."tbTipoSeguro".id_tipo_seguro;
	END;
	$$ LANGUAGE plpgsql;
			   
	(CRUD)=> tbTipoReaseguro == tbTipoSeguro == tbTipoSiniestro == tbTipoCobertura <=(CRUD)
			   			   
			   	   		   
			   	   
			   			   
	S A L I D A S
//REPORTE DE CLIENTES CON RECLAMACIONES RECHAZADAS
-- fecha del reporte
	Para cada cliente
	--nombre del cliente
	--numero de identificacion
	--cantidad de reclamaciones rechazadas
	--motivo de rechazo

	//SALIDA de [nombre_cliente + numero_identidad_cliente + cantidad_reclamaciones_rechazadas]
	salida_cliente_con_cantidad_reclamacion_rechazada
		SELECT  public."tbCliente".nombre_cliente, public."tbCliente".numero_identidad_cliente,
				COUNT(public."tbReclamacion".numero_reclamacion)
		FROM public."tbReclamacion", public."tbPoliza", public."tbCliente"
		WHERE public."tbPoliza".numero_poliza = public."tbReclamacion".numero_poliza AND 
			public."tbReclamacion".id_estado_reclamacion = 3 AND
			public."tbPoliza".numero_identidad_cliente = public."tbCliente".numero_identidad_cliente
		GROUP BY  public."tbCliente".numero_identidad_cliente
	//funcion para obtener los motivo de rechazo dado el cliente
		CREATE OR REPLACE FUNCTION salida_motivo_rechazo_reclamacion (p_numero_identidad_cliente INTEGER)
		RETURNS TABLE (motivo_rechazo TEXT) AS $$
		BEGIN
			RETURN QUERY
			SELECT  public."tbMotivoRechazoReclamacion".motivo_rechazo
			FROM public."tbMotivoRechazoReclamacion", public."tbPoliza", public."tbReclamacion"
			WHERE public."tbPoliza".numero_poliza = public."tbReclamacion".numero_poliza AND 
				public."tbMotivoRechazoReclamacion".numero_reclamacion = public."tbReclamacion".numero_reclamacion  AND
				public."tbPoliza".numero_identidad_cliente = p_numero_identidad_cliente;
		END;
		$$ LANGUAGE plpgsql;

//REPORTE DE CLIENTES CON RECLAMACIONES APROBADAS
-- fecha del reporte
	Para cada cliente
	--nombre del cliente
	--numero de identificacion
	--cantidad de reclamaciones aprobadas
	--total del monto indemnizado
	
	//SALIDA de [nombre_cliente + numero_identidad_cliente + cantidad_reclamaciones_rechazadas + total_monto_indemnizado]
	salida_cliente_con_cantidad_reclamacion_aprobada
		SELECT "tbCliente".nombre_cliente,
			"tbCliente".numero_identidad_cliente,
			count("tbReclamacion".numero_reclamacion),
			SUM("tbReclamacion".monto_indemnizado)
		FROM "tbReclamacion",
			"tbPoliza",
			"tbCliente"
		WHERE "tbPoliza".numero_poliza = "tbReclamacion".numero_poliza AND "tbReclamacion".id_estado_reclamacion = 1 AND "tbPoliza".numero_identidad_cliente = "tbCliente".numero_identidad_cliente
		GROUP BY "tbCliente".numero_identidad_cliente;

//LISTADO DE CLIENTES
-- fecha del reporte
	Para cada pais
	--pais
	Para cada cliente de ese pais
		--nombre del cliente
		--numero de identificacion
		--cantidad de reclamaciones aprobadas
		--total del monto indemnizado
		
	//salida para obtener los paises
		SELECT * FROM public."tbPais"
		ORDER BY id_pais ASC ;
	//para obtener la cantidad de polizas activas de un cliente dado un pais
		CREATE OR REPLACE FUNCTION salida_polizas_activas_cliente (p_id_pais INTEGER)
		RETURNS TABLE (nombre_cliente VARCHAR, numero_identidad_cliente INTEGER, id_estado_poliza BIGINT)
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
		$$ LANGUAGE plpgSQL;
	//para obtener el total de las primas pagadas por un cliente dado un pais	   
		CREATE OR REPLACE FUNCTION salida_polizas_activas_cliente (p_id_pais INTEGER)
		RETURNS TABLE (nombre_cliente VARCHAR, numero_identidad_cliente INTEGER, id_estado_poliza BIGINT)
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
		$$ LANGUAGE plpgSQL;
		