private List<PartInfo> uploadParts(String encodedPath, String uploadId, int startPartNumber, Map<String, String> headers,
            InputStream in,
            boolean isAbort) {
        List<PartInfo> completeParts = new LinkedList<>();
        int partNumber = startPartNumber;
        try (in) {
            int len = -1;
            byte[] buf = new byte[PART_SIZE];
            do {
                int readLen = 0;
                while (true) {
                    len = in.read(buf, readLen, PART_SIZE - readLen);
                    if (len == -1 || readLen == PART_SIZE) {
                        break;
                    }
                    readLen += len;
                }
                PartInfo completePart = uploadPart(encodedPath, uploadId, partNumber, headers, buf, readLen, isAbort);
                completeParts.add(completePart);
                partNumber++; // 멀티 파트 업로드 성공시 파트번호 증가
            } while (len != -1);
        } catch (RuntimeException | IOException e) {
            String errMsg = String.format("Part upload failed - partNumber : [%d], uploadId : [%s]", partNumber, uploadId);
            LOG.error(errMsg, e);
            throw new IllegalStateException(errMsg, e);
        }
        return completeParts;
    }
