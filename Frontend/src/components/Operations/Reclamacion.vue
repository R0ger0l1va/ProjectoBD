<template>
  <div class="formulario">
    <h2>Formulario de Reclamación</h2>
    <form @submit.prevent="enviarReclamacion">
      <div class="campo">
        <label for="numeroPoliza">Número de Póliza:</label>
        <input id="numeroPoliza" v-model="reclamacion.numeroPoliza" required>
      </div>
      <div class="campo">
        <label for="numeroReclamacion">Número de Reclamación:</label>
        <input id="numeroReclamacion" v-model="reclamacion.numeroReclamacion" required>
      </div>
      <div class="campo">
        <label for="fechaSiniestro">Fecha del Siniestro:</label>
        <input id="fechaSiniestro" v-model="reclamacion.fechaSiniestro" type="date" required>
      </div>
      <div class="campo">
        <label for="montoIndemnizacion">Monto de Indemnización:</label>
        <input id="montoIndemnizacion" v-model.number="reclamacion.montoIndemnizacion" type="number" required>
      </div>
      <div class="campo">
        <label for="montoReclamado">Monto Reclamado:</label>
        <input id="montoReclamado" v-model.number="reclamacion.montoReclamado" type="number" required>
      </div>
      <div class="campo">
        <label for="tipoSiniestro">Tipo de Siniestro:</label>
        <select id="tipoSiniestro" v-model="reclamacion.tipoSiniestro" required>
          <option value="">Seleccione un tipo</option>
          <option value="accidente">Accidente</option>
          <option value="robo">Robo</option>
          <option value="incendio">Incendio</option>
          <option value="otro">Otro</option>
        </select>
      </div>
      <button type="submit" class="boton-submit">Enviar Reclamación</button>
    </form>
  </div>
</template>

<script>
export default {
  name: 'Reclamacion',
  data() {
    return {
      reclamacion: {
        numeroPoliza: '',
        numeroReclamacion: '',
        fechaSiniestro: '',
        montoIndemnizacion: null,
        montoReclamado: null,
        tipoSiniestro: ''
      }
    }
  },
  methods: {
    enviarReclamacion() {
      console.log('Reclamación enviada:', this.reclamacion);
      alert('Reclamación enviada con éxito');
      this.reclamacion = {
        numeroPoliza: '',
        numeroReclamacion: '',
        fechaSiniestro: '',
        montoIndemnizacion: null,
        montoReclamado: null,
        tipoSiniestro: ''
      };
    }
  }
}
</script>

<style scoped>
.formulario {
  background-color: white;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 0 5px rgba(0,0,0,0.1);
}

.campo {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input, select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.boton-submit {
  padding: 10px 15px;
  background-color: #4CAF50;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 4px;
  font-size: 14px;
}
</style>