const pg = require('./connect');

const addClient = async (params) => {
    const { id_pais, id_sexo, nombre_cliente, apellido_cliente, edad, direccion_postal, telefono, correo_electronico, carnet_identidad } = params;
    const result = await pg.query(`SELECT * FROM tbcliente_insert($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
        [id_pais, id_sexo, nombre_cliente, apellido_cliente, edad, direccion_postal, telefono, correo_electronico, carnet_identidad]);
    return result.rows[0];
}

module.exports = {
    addClient,
}