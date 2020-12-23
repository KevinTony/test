#pragma once
//SyncQueue.hpp

#include <unistd.h>

#include <list>
#include <mutex>
#include <condition_variable>
#include <iostream>

template<typename T>
class BlockQueue
{
public:
    BlockQueue()
    {
    }

	BlockQueue(const BlockQueue&) = delete;
	BlockQueue& operator=(const BlockQueue&) = delete;

    int getSize()
    {
        std::unique_lock<std::mutex> locker(m_mutex);

        return m_queue.size();
    }

    bool IsEmpty() const
    {
        return m_queue.empty();
    }

    void Put(const T& x)
    {
        std::unique_lock<std::mutex> locker(m_mutex);

        m_queue.push_back(x);
    }

    int Take(T& x)
    {
        std::unique_lock<std::mutex> locker(m_mutex);

        if(m_queue.empty())
        {
            return -1;
        }

        x = m_queue.front();
        m_queue.pop_front();
        return 0;
    }
    
    // wait for: times * 1000 / 1000 000 s
    // if times == -1: blocking util get the data
    int TakeBlocking(T& x, int times)
    {
        for (int i = 0; i < times || times == -1; ++i) {
            int res = Take(x);
            if (res == 0)
                return 0;
            usleep(1000);
        }
        return -1;
    }

    void cleanTake(T& x)
    {
        std::unique_lock<std::mutex> locker(m_mutex);   
        x = m_queue.front();
        m_queue.pop_front();
    }
    void clear(){
        std::unique_lock<std::mutex> locker(m_mutex);  
        m_queue.clear();   
        m_queue.resize(0);  
    }
    void clear_d(){
        std::unique_lock<std::mutex> locker(m_mutex);  
        while (!m_queue.empty())
        {
            T x;
            x = m_queue.front();
            m_queue.pop_front();
            delete x;
            
        }
    }
private:
    std::list<T> m_queue;
    std::mutex m_mutex;
};
