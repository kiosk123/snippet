public byte[] zip(byte[] data) throws IOException {
    return zip(data, Deflater.BEST_COMPRESSION);
}

public byte[] zip(byte[] data, int level) throws IOException {
    byte[] rtnValue = null;
    ByteArrayOutputStream baos = null;
    DeflaterOutputStream dos = null;
    
    Deflater deflater = new Deflater(level);
    try {
        baos = new ByteArrayOutputStream();
        dos = new DeflaterOutputStream(baos, deflater);
        dos.write(data);
        dos.flush();
        baos.flush();
        dos.finish();
        rtnValue = baos.toByteArray();
    } finally {
        if(dos != null) {
            try { dos.close(); } catch(Exception ee) {}
        }
        if(baos != null) {
            try { baos.close(); } catch(Exception ee) {}
        }
    }
    return rtnValue;
}

public byte[] unzip(byte[] data) throws IOException {
    byte[] rtnValue = null;
    ByteArrayOutputStream baos = null;
    ByteArrayInputStream bais = null;
    InflaterInputStream iis = null;
    try {
        baos = new ByteArrayOutputStream();
        bais = new ByteArrayInputStream(data);
        iis = new InflaterInputStream(bais);
        byte[] buffer = new byte[1024];
        int readLen = -1;
        while (true) {
            readLen = iis.read(buffer);
            if(readLen < 0) {
                break;
            }
            baos.write(buffer, 0, readLen);
        }
        baos.flush();
        rtnValue = baos.toByteArray();
    } finally {
        if(iis != null) {
            try { iis.close(); } catch(Exception ee) {}
        }
        if(baos != null) {
            try { baos.close(); } catch(Exception ee) {}
        }
        if(bais != null) {
            try { bais.close(); } catch(Exception ee) {}
        }
    }
    return rtnValue;
}

public byte[] gzip(byte[] data) throws IOException {
    byte[] rtnValue = null;
    ByteArrayOutputStream baos = null;
    GZIPOutputStream zos = null;
    try {
        baos = new ByteArrayOutputStream();
        zos = new GZIPOutputStream(baos);
        zos.write(data);
        zos.flush();
        baos.flush();
        zos.finish();
        rtnValue = baos.toByteArray();
    } finally {
        if(zos != null) {
            try { zos.close(); } catch(Exception ee) {}
        }
        if(baos != null) {
            try { baos.close(); } catch(Exception ee) {}
        }
    }
    return rtnValue;
}

public byte[] gunzip(byte[] data) throws IOException {
    byte[] rtnValue = null;
    ByteArrayOutputStream baos = null;
    ByteArrayInputStream bais = null;
    GZIPInputStream zis = null;
    try {
        baos = new ByteArrayOutputStream();
        bais = new ByteArrayInputStream(data);
        zis = new GZIPInputStream(bais);
        byte[] buffer = new byte[1024];
        int readLen = -1;
        while (true) {
            readLen = zis.read(buffer);
            if(readLen < 0) {
                break;
            }
            baos.write(buffer, 0, readLen);
        }
        rtnValue = baos.toByteArray();
    } finally {
        if(zis != null) {
            try { zis.close(); } catch(Exception ee) {}
        }
        if(baos != null) {
            try { baos.close(); } catch(Exception ee) {}
        }
        if(bais != null) {
            try { bais.close(); } catch(Exception ee) {}
        }
    }
    return rtnValue;
}
