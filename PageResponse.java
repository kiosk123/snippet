public final class PageResponse<T> {

    public static final int DEFAULT_PAGE_SIZE = 30;

    private final int curPage;

    private final int pageSize;

    private final long total;

    private List<T> list;

    public PageResponse() {
        // 테스트를 위해 생성
        curPage = 1;
        pageSize = DEFAULT_PAGE_SIZE;
        total = 0;
    }

    public PageResponse(long total, int size, int pageNum) {
        if (total < 0) {
            throw new IllegalArgumentException("total: " + total);
        }
        if (size < 0) {
            throw new IllegalArgumentException("size: " + size);
        }
        this.total = total;
        this.pageSize = size;

        if (total == 0) {
            this.curPage = 1;
        } else {
            int mod = (int) (total % pageSize);
            int div = (int) (total / pageSize);
            int lastPageNum = mod == 0 ? div : div + 1;
            this.curPage = pageNum <= lastPageNum ? pageNum : lastPageNum;
        }
    }

    public int getCurPage() {
        return curPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public long getTotal() {
        return total;
    }

    public List<T> getList() {
        return list;
    }

    public void setList(List<T> list) {
        this.list = list;
    }

}
