public class Paging {

    public static void main(String[] args) {
        //한페이지에 보일 게시물의 수
        int rowInPage = 10;     
        
        //한페이지에 보일 페이지의 수
        int pageLength  = 10; 
        
        int curPage = 10; //현재 페이지 번호
        
        //DB에서 추출할 게시물 시작 ROW (0부터 시작)
        int startRow = (curPage - 1) * rowInPage;
        
        //DB에서 추출할 게시물 마지막 ROW - DB마다 다를수 있지만 JPA를 쓸경우 한페이지에 보일 게시물 수로 세팅
        int endRow = (curPage * rowInPage) - startRow + 1; 
        
        //전체 게시물 수
        int totalCount = 10000;
        
        
        /**
         * 페이징 처리
         */
        //전체 페이지수
        int totalPageCount = (int)Math.ceil((double)totalCount / (double)rowInPage);
        
        //시작 페이지 번호
        int pageStart = ((curPage - 1) / pageLength) * pageLength + 1;
        
        //끝 페이지 번호
        int pageEnd = pageStart + pageLength - 1;
        
        if (pageEnd > totalPageCount) {
            pageEnd = totalPageCount;
        }
        
        if (pageStart > pageLength) {
            int prePage = pageStart - pageLength;
            System.out.println("이전 페이지 : " + prePage);
        }
        
        //페이지 번호 출력
        for (int i = pageStart; i <= pageEnd; i++) {
            System.out.print(i + " ");
        }
        System.out.println();
        
        if (pageEnd < totalPageCount) {
            int nextPage = pageStart + pageLength;
            System.out.println("다음 페이지 : " + nextPage);
        }
        
    }
}
