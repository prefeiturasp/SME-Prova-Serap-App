enum JobsEnum {
  SINCRONIZAR_RESPOSTAS('SincronizarRespostasWorker'),
  FINALIZAR_PROVA('FinalizarProvaWorker'),
  REMOVER_PROVAS_EXPIRADAS('RemocaoProvasExpiradas');

  const JobsEnum(this.uniqueName);

  final String uniqueName;

  static JobsEnum? parse(String task) {
    for (var job in JobsEnum.values) {
      if (task == job.uniqueName) {
        return job;
      }
    }
  }
}
