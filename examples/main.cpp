#include "lltm.h"

int main(){
    const auto output = torch::ones({1, 3, 5, 5});
    std::cout << output.slice(/*dim=*/1, /*start=*/0, /*end=*/5) << '\n';

    return 0;
}
