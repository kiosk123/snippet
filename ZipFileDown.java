    public ResponseEntity<Object> exportRule(@RequestBody Map<String, Object> params) throws Exception {
        String ruleTypeStr = (String) params.get("ruleType");
        RuleType ruleType = ControllerUtil.ruleType(ruleTypeStr);

        RuleService<? extends RuleVo> ruleService = RuleUtil.getRuleService(appCtx, ruleType);

        @SuppressWarnings("unchecked")
        List<String> ids = (List<String>) params.get("ids");

        byte[] data = null;
        String filename = null;
        if (ids.size() == 1) {
            ExportData ex = findRule(ruleService, ids.get(0));
            data = ex.data;
            filename = ex.filename;
        } else {
            try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    ZipOutputStream out = new ZipOutputStream(baos)) {

                for (String idStr : ids) {
                    try {
                        ExportData ex = findRule(ruleService, idStr);
                        out.putNextEntry(new ZipEntry(ex.filename));
                        out.write(ex.data);
                    } finally {
                        out.closeEntry();
                    }
                }
                out.finish();
                data = baos.toByteArray();
            } catch (Exception e) {
                throw e;
            }
            String now = DateTimeFormatter.ofPattern(HerbUtil.FULLDATEFORMAT).format(LocalDateTime.now());
            filename = "IntegrationService_" + now + ".zip";
        }

        MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
        headers.set("Content-Type", "application/octet-stream");
        headers.set("Content-Disposition", "attachment;filename=" + filename);
        return new ResponseEntity<Object>(data, headers, HttpStatus.OK);
    }
